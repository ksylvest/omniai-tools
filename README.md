# OmniAI::Tools

[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ksylvest/omniai-tools/blob/main/LICENSE)
[![RubyGems](https://img.shields.io/gem/v/omniai-tools)](https://rubygems.org/gems/omniai-tools)
[![GitHub](https://img.shields.io/badge/github-repo-blue.svg)](https://github.com/ksylvest/omniai-tools)
[![Yard](https://img.shields.io/badge/docs-site-blue.svg)](https://omniai-tools.ksylvest.com)
[![CircleCI](https://img.shields.io/circleci/build/github/ksylvest/omniai-tools)](https://circleci.com/gh/ksylvest/omniai-tools)

`OmniAI::Tools` is a library of pre-built tools to simplify integrating common tasks with [OmniAI](https://github.com/ksylvest/omniai).

## Browser

Browser tools allow you to interact with any website (e.g. visit a page, click on a button, fill in some text, etc):

```ruby
require "omniai/openai"
require "omniai/tools"

client = OmniAI::OpenAI::Client.new

logger = Logger.new($stdout)
driver = OmniAI::Tools::Browser::WatirDriver.new
tools = [OmniAI::Tools::BrowserTool.new(driver: logger:)]

puts "Type 'exit' or 'quit' to leave."

prompt = OmniAI::Chat::Prompt.build do |builder|
  builder.system <<~TEXT
    You are tasked with assisting a user in browsing the web.
  TEXT
end

loop do
  print "# "
  text = gets.strip
  break if %w[exit quit].include?(text)

  prompt.user(text)
  response = client.chat(prompt, stream: $stdout, tools:)
  prompt.assistant(response.text)
end
```

```
Type 'exit' or 'quit' to leave.
# Visit news.ycombinator.com and list the top 5 posts.

[browser] OmniAI::Tools::Browser::VisitTool#execute url="https://news.ycombinator.com"
[browser] OmniAI::Tools::Browser::InspectTool#execute

Here are the top 5 posts on Hacker News right now:

...
```

## Computer

A computer tool grants the ability to manage a computer via an LLM:

```ruby
require "omniai/openai"
require "omniai/tools"

require "macos"

client = OmniAI::OpenAI::Client.new
logger = Logger.new($stdout)
logger.formatter = proc { |_, _, _, message| "[computer] #{message}\n" }

driver = OmniAI::Tools::Computer::MacDriver.new
tools = [OmniAI::Tools::ComputerTool.new(driver:, logger:)]

puts "Type 'exit' or 'quit' to leave."

loop do
  print "# "
  text = gets.strip
  break if %w[exit quit].include?(text)

  driver.screenshot do |file|
    client.chat(stream: $stdout, tools:) do |prompt|
      prompt.system <<~TEXT
        Assist the user with tasks related to the use their computer.

        1. The display is #{driver.display_width}px (w) × #{driver.display_height}px (h).
        2. Attached find a screenshot of the display that may be inspected to determine the state of the computer.
        3. The computer is using MacOS with all the expected applications (e.g. Finder, Safari, etc).
        4. Any coordinates used for clicking must be scaled for the bounds of the display.
        5. Whenever possible prefer to navigate using keyboard shortcuts rather than mouse clicks.
      TEXT

      prompt.user do |message|
        message.text(text)
        message.file(file.path, "image/png")
      end
    end
  end
end
```

```
Type 'exit' or 'quit' to leave.

# What do you see on my screen?

Here's what I see on your screen:
- You are using a Mac with a display resolution of 2560×1440 pixels.
- The Terminal app is open at the very top, with a command prompt in a directory related to "omnial-tools" and "computer".
- Below the Terminal, Visual Studio Code (VS Code) is open showing a project directory named "omnial-tools", specifically in a folder like /examples/computer.

# Please open Safari

[computer] action="mouse_click" coordinate={x: 484, y: 1398} mouse_button="left"
Safari is being opened now. Let me know if you need to visit a specific website or perform any other actions in Safari!

# What is the current position of my mouse?

[computer] action="mouse_position"
Your mouse is currently positioned at approximately (484, 1398) on your screen.
```

## Database

Database tools are focused on running SQL statements:

```ruby
require "omniai/openai"
require "omniai/tools"

require "sqlite3"

db = SQLite3::Database.new(":memory:")
driver = OmniAI::Tools::Database::SqliteDriver.new(db:)

client = OmniAI::OpenAI::Client.new
logger = Logger.new($stdout)

tools = [OmniAI::Tools::DatabaseTool.new(logger:, driver:)]

puts "Type 'exit' or 'quit' to leave."

prompt = OmniAI::Chat::Prompt.build do |builder|
  builder.system "Use tools to manage a database as requested."
end

loop do
  print "# "
  text = gets.strip
  break if %w[exit quit].include?(text)

  prompt.user(text)
  response = client.chat(prompt, stream: $stdout, tools:)
  prompt.assistant(response.text)
end
```

```
Type 'exit' or 'quit' to leave.
# Generate tables for artists, albums, songs, bands, members and populate it with data surrounding the Beatles.

CREATE TABLE artists (id INTEGER PRIMARY KEY, name TEXT NOT NULL)
CREATE TABLE bands (id INTEGER PRIMARY KEY, name TEXT NOT NULL)
CREATE TABLE members (id INTEGER PRIMARY KEY, artist_id INTEGER, band_id INTEGER, FOREIGN KEY(artist_id) REFERENCES artists(id), FOREIGNKEY(band_id) REFERENCES bands(id))"
CREATE TABLE albums (id INTEGER PRIMARY KEY, title TEXT NOT NULL, band_id INTEGER, FOREIGN KEY(band_id) REFERENCES bands(id))
CREATE TABLE songs (id INTEGER PRIMARY KEY, title TEXT NOT NULL, album_id INTEGER, FOREIGN KEY(album_id) REFERENCES albums(id))
...
```

## Disk

Disk tools are focused on creating, updating, and deleting files and directories within a "root":

```ruby
require "omniai/openai"
require "omniai/tools"

print "Root (e.g. /usr/src/project): "
root = gets.strip

client = OmniAI::OpenAI::Client.new
logger = Logger.new($stdout)
logger.formatter = proc { |_, _, _, message| "[disk] #{message}\n" }

driver = OmniAI::Tools::Disk::LocalDriver.new(root:)
tools = [OmniAI::Tools::DiskTool.new(driver:, logger:)]

puts "Type 'exit' or 'quit' to leave."

prompt = OmniAI::Chat::Prompt.build do |builder|
  builder.system "Use tools to manage files and directories as requested."
end

loop do
  print "# "
  text = gets.strip
  break if %w[exit quit].include?(text)

  prompt.user(text)
  response = client.chat(prompt, stream: $stdout, tools:)
  prompt.assistant(response.text)
end
```

## Docker

Docker tools are focused on running commands through Docker via Compose:

```ruby
require "omniai/openai"
require "omniai/tools"

print "Root (e.g. /usr/src/project): "
root = gets.strip

client = OmniAI::OpenAI::Client.new
logger = Logger.new($stdout)

tools = [
  OmniAI::Tools::Docker::ComposeRunTool,
].map { |klass| klass.new(root:, logger:) }

puts "Type 'exit' or 'quit' to leave."

prompt = OmniAI::Chat::Prompt.build do |builder|
  builder.system "Use tools to interact with Docker."
end

loop do
  print "# "
  text = gets.strip
  break if %w[exit quit].include?(text)

  prompt.user(text)
  response = client.chat(prompt, stream: $stdout, tools:)
  prompt.assistant(response.text)
end
```
