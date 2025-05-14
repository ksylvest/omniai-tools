# OmniAI::Tools

[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ksylvest/omniai-tools/blob/main/LICENSE)
[![RubyGems](https://img.shields.io/gem/v/omniai-tools)](https://rubygems.org/gems/omniai-tools)
[![GitHub](https://img.shields.io/badge/github-repo-blue.svg)](https://github.com/ksylvest/omniai-tools)
[![Yard](https://img.shields.io/badge/docs-site-blue.svg)](https://omniai-tools.ksylvest.com)
[![CircleCI](https://img.shields.io/circleci/build/github/ksylvest/omniai-tools)](https://circleci.com/gh/ksylvest/omniai-tools)

`OmniAI::Tools` is a library of pre-built tools to simplify integrating common tasks with [OmniAI](https://github.com/ksylvest/omniai).

## Database

Database tools are focused on running SQL statements:

```ruby
require "omniai/openai"
require "omniai/tools"

require "sqlite3"

db = SQLite3::Database.new(":memory:")

client = OmniAI::OpenAI::Client.new
logger = Logger.new($stdout)

tools = [
  OmniAI::Tools::Database::SqliteTool.new(logger:, db:),
]

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

tools = [
  OmniAI::Tools::Disk::DirectoryCreateTool,
  OmniAI::Tools::Disk::DirectoryDeleteTool,
  OmniAI::Tools::Disk::FileCreateTool,
  OmniAI::Tools::Disk::FileDeleteTool,
  OmniAI::Tools::Disk::FileMoveTool,
  OmniAI::Tools::Disk::FileReplaceTool,
  OmniAI::Tools::Disk::FileReadTool,
  OmniAI::Tools::Disk::FileWriteTool,
  OmniAI::Tools::Disk::SummaryTool,
].map { |klass| klass.new(root:, logger:) }

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
