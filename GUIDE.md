# Building a Ruby Coder Agent with OmniAI

Thorsten Ball recently published [How to Build an Agent](https://ampcode.com/how-to-build-an-agent) documenting the steps needed to build an AI agent that can read and write code using Go. This tackles the same problem, but for Ruby using [OmniAI](https://github.com/ksylvest/omniai). OmniAI is a provider (e.g. Anthropic, Google, OpenAI, etc) agnostic Ruby gem. This example is built using OpenAI, but any LLM provider be used.

## Step 1. Configuring an Agent

The agent being built is going to run via the terminal using an `agent.rb` entrypoint. This entrypoint is going to do four things in a loop:

1. Wait for the user to enter some text.
2. Attach that text to the prompt (that is persisted between loops).
3. Send the prompt to the LLM and displays the response.
4. Attach the result to the prompt (that is persisted between loops).

**agent.rb**

```ruby
require 'bundler/inline'

gemfile do
  gem 'omniai-openai'
  gem 'zeitwerk'
end

client = OmniAI::OpenAI::Client.new

prompt = OmniAI::Chat::Prompt.build do |builder|
  builder.system <<~TEXT
    You are an expert programmer tasked with pairing with another engineer.
  TEXT
end

loop do
  OUTPUT.print '> '
  text = INPUT.gets.chomp
  break if text.eql?('exit') || text.eql?('quit')

  prompt.user(text)

  response = client.chat(prompt, stream: $stdout)

  prompt.assistant(response.text)
end
```

Let's test it:

```bash
ruby agent.rb
```

```
Type 'bye' to leave.

> How can I define a class?

You can define a class in **Python** using the `class` keyword:

    class ExampleClass:
        def __init__(self, value):
            self.value = value

> But I use Ruby...

No problem! Here’s how you define a class in **Ruby**:

    class Example
      def initialize(value)
        @value = value
      end
    end

> bye
```

This gives the basic input / output loop needed. It tracks history (e.g. 'But I use Ruby...' understands the initial definition of a class question). This integration currently lacks the ability to interact with anything (that's next).

## Step 2: Defining a Tool

For an agent to be capable of coding it needs tools (lots of tools). Those tools can all live inside a `tools` folder in our project. To ensure tools are autoload [zeitwerk](https://github.com/fxn/zeitwerk) may be setup:

**agent.rb**

```ruby
require 'bundler/inline'

gemfile do
  gem 'omniai-openai'
  gem 'zeitwerk'
end

ROOT = Pathname(__dir__)

loader = Zeitwerk::Loader.new
loader.push_dir(ROOT.join('tools'))
loader.setup()

# ...
```

Next, a tool is defined to summarize the contents of a "project" (directory). Specifically this tool lists all of the files and folders inside the "project":

**tools/project_summary_tool.rb**

```ruby
class ProjectSummaryTool < OmniAI::Tool
  description "List the contents (files and directories) of the project."

  # @param directory [Pathname]
  # @param logger [Logger]
  def initialize(directory:, logger:)
    super()
    @directory = directory
    @logger = logger
  end

  # @return [String]
  def execute
    @logger.info("#{self.class.name}#execute")

    Dir.chdir(@directory) do
      result = Dir.glob("**/*").map do |path|
        if File.directory?(path)
          "📁 ./#{path}/"
        else
          "📄 ./#{path} (#{File.size(path)} bytes)"
        end
      end.join("\n")

      @logger.debug(result)

      result
    end
  end
end
```

This tool is then initialized with a path to the "project" and provided to our agent for use:

**agent.rb**

```ruby
# ...

ROOT = Pathname(__dir__)
PROJECT = ROOT.join("project")

loader = Zeitwerk::Loader.new
# ..

logger = Logger.new($stdout)
logger.formatter = proc { |_, _, _, message| "# #{message}\n" }
tools = [ProjectSummaryTool.new(directory: PROJECT, logger:)]

# ...

loop do
  # ...
  response = client.chat(prompt, stream: $stdout, tools:)
  # ...
end
```

We'll also setup a `project` folder and with a file called `fibonacci.rb` for testing:

```bash
ruby agent.rb
```

```
Type 'bye' to leave.

> What files / folders are available in my project?

# ProjectSummaryTool#execute
# 📄 ./fibonacci.rb (0 bytes)

Your project currently contains the following:

- ./fibonacci.rb (0 bytes)

No other files or folders are present. Let me know how you’d like to proceed!
```

The agent is now effectively able to explore a project to a very limited extent!

## Step 3: Defining More Tools

Now that our agent is capable of listing files, the next thing it needs is for the ability to read / write files. This is accomplished by introducing two additional tools:

**tools/file_read_tool.rb**

```ruby
class FileReadTool < OmniAI::Tool
  description "Read the contents of a file."

  parameter :path, :string, description: "a path for the file (e.g. `./main.rb`)"

  # @param directory [Pathname]
  # @param logger [IO]
  def initialize(directory:, logger:)
    super()
    @directory = directory
    @logger = logger
  end

  # @param path [String]
  #
  # @return [String]
  def execute(path:)
    @logger.info("#{self.class.name}#execute path=#{path}")
    File.read(@directory.join(path))
  rescue => e
    @logger.warn("ERROR: #{e.message}")
    return "ERROR: #{e.message}"
  end
end
```

**tools/file_write_tool.rb**

```ruby
class FileWriteTool < OmniAI::Tool
  description "Write the contents of a file."

  parameter :path, :string, description: "a path for the file (e.g. `./main.rb`)"
  parameter :text, :string, description: "the text to write to the file (e.g. `puts 'Hello World'`)"

  # @param directory [Pathname]
  # @param logger [IO]
  def initialize(directory:, logger:)
    super()
    @directory = directory
    @logger = logger
  end

  # @param path [String]
  # @param text [String]
  #
  # @return [String]
  def execute(path:, text:)
    @logger.info("#{self.class.name}#execute path=#{path}")
    File.write(@directory.join(path), text)
  rescue => e
    @logger.warn("ERROR: #{e.message}")
    return "ERROR: #{e.message}"
  end
end
```

These tools are also initialized and configured for our agent with the same "project" folder:

**agent.rb**

```ruby
# ...
tools = [
  ProjectSummaryTool.new(directory: PROJECT, logger:),
  FileReadTool.new(directory: PROJECT, logger:),
  FileWriteTOol.new(directory: PROJECT, logger:),
]
```

Let's also adjust the system prompt slightly to give it some extra guidance:

```ruby
prompt = OmniAI::Chat::Prompt.build do |builder|
  builder.system <<~TEXT
    You are an expert programmer tasked with reading and writing code.
    Please use the provided tools when possible to accomplish any tasks.
  TEXT
end
```

Then the project may be tested again:

```bash
ruby agent.rb
```

```
Type 'bye' to leave.

> Implement the fibonacci function. Also provide automated tests w/ RSpec for it.
# ProjectSummaryTool#execute
# 📄 ./fibonacci.rb (0 bytes)
# FileWriteTool#execute path=./fibonacci.rb
# FileWriteTool#execute path=./fibonacci_spec.rb
I've implemented a recursive Fibonacci function in `fibonacci.rb`. I've also defined several tset cases in `fibonacci_spec.rb`.
```

Checking on the LLM, it seems like the results are fit our request perfectly:

**project/fibonacci.rb**

```ruby
def fibonacci(n)
  return 0 if n == 0
  return 1 if n == 1

  fibonacci(n - 1) + fibonacci(n - 2)
end
```

**project/fibonacci_spec.rb**

```ruby
require_relative './fibonacci'

describe '#fibonacci' do
  it 'returns 0 for 0' do
    expect(fibonacci(0)).to eq(0)
  end

  it 'returns 1 for 1' do
    expect(fibonacci(1)).to eq(1)
  end

  it 'returns 1 for 2' do
    expect(fibonacci(2)).to eq(1)
  end

  it 'returns 2 for 3' do
    expect(fibonacci(3)).to eq(2)
  end

  it 'returns 3 for 4' do
    expect(fibonacci(4)).to eq(3)
  end

  it 'returns 5 for 5' do
    expect(fibonacci(5)).to eq(5)
  end
end
```

The `FileReadTool` and `FileWriteTool` do not sanitize the paths to ensure they are children of the project directory. This may allow for the LLM to make a nefarious tool call to with a path containing ".." to 'escape' our project directory. This may be fixed via the following code, but for simplicty it is excluded in the examples:

**app/tools/concerns/resolve.rb**

```ruby
module Resolve
  # @param directory [Pathname]
  # @param path [String]
  #
  # @raise [SecurityError]
  #
  # @return Pathname
  def resolve!(directory:, path:)
    resolved = @directory.join(path)
    if resolved.ascend.none? { |ancestor| ancestor.eql?(@directory) }
      raise SecurityError, "unsupported path=#{path}"
    end
    resolved
  end
end
```

## Step 4: Executing Code

Our agent now has the ability read and write code. At this point the next logical step is to give it a sandbox to run code... This is a bit of a scary proposition though... While it'd be possible to use `eval`, it is a bit of a scary proposition to run arbitrary code on host OS. In this case Docker (w/ compose) offers a passable sandbox for our agent.

**Dockerfile**

```Dockerfile
# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.4.2
FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

WORKDIR /project

COPY ./project/Gemfile* ./

RUN bundle install
```

**compose.yml**

```yaml
services:
  app:
    build: .
    volumes:
      - ./project:/project
```

Then, once again a tool is needed to grant access to the LLM to this environment:

```ruby
class ProjectRunTool < OmniAI::Tool
  description "Run a command with arguments (e.g. `rspec spec/main_spec.rb`)."

  parameter :command, :string, description: "the command to run (e.g. `rspec`)"
  parameter :arguments, :array, description: "the arguments for the command",
    items: OmniAI::Tool::Property.string(description: 'an argument for the command (e.g. `spec/main_spec.rb`)')

  # @param directory [Pathname]
  # @param logger [IO]
  def initialize(directory:, logger:)
    super()
    @directory = directory
    @logger = logger
  end

  # @param command [String]
  #
  # @return [String]
  def execute(command:, arguments: [])
    @logger.info("#{self.class.name}#execute command=#{command.inspect} arguments=#{arguments.inspect}")

    Dir.chdir(@directory) do
      text, status = Open3.capture2e("docker", "compose", "run", "--rm", "app", command, *arguments)

      @logger.debug("status=#{status.inspect}")
      @logger.debug(text)

      text
    end
  end
end
```

This tool may be ammended into our growing list of tools given to our agent:

```ruby
tools = [
  ProjectSummaryTool.new(directory: PROJECT, logger:),
  FileReadTool.new(directory: PROJECT, logger:),
  FileWriteTool.new(directory: PROJECT, logger:),
  ProjectRunTool.new(directory: PROJECT, logger:),
]
```
