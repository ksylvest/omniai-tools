# frozen_string_literal: true

module OmniAI
  module Tools
    # A tool for interacting with a computer. Be careful with using as it can perform actions on your computer!
    #
    # @example
    #   computer = OmniAI::Tools::Computer::MacTool.new
    #   computer.display # { "width": 2560, "height": 1440, "scale": 1 }
    #   computer.screenshot
    class ComputerTool < OmniAI::Tool
      description "A tool for interacting with a computer."

      module Action
        DIRECTORY_CREATE = "directory_create"
        DIRECTORY_DELETE = "directory_delete"
        DIRECTORY_MOVE = "directory_move"
        DIRECTORY_LIST = "directory_list"
        FILE_CREATE = "file_create"
        FILE_DELETE = "file_delete"
        FILE_MOVE = "file_move"
        FILE_READ = "file_read"
        FILE_WRITE = "file_write"
        FILE_REPLACE = "file_replace"
      end

      ACTIONS = [
        Action::DIRECTORY_CREATE,
        Action::DIRECTORY_DELETE,
        Action::DIRECTORY_MOVE,
        Action::DIRECTORY_LIST,
        Action::FILE_CREATE,
        Action::FILE_DELETE,
        Action::FILE_MOVE,
        Action::FILE_READ,
        Action::FILE_WRITE,
        Action::FILE_REPLACE,
      ].freeze

      parameter :action, :string, enum: ACTIONS, description: <<~TEXT
        Options:
        * `#{Action::DIRECTORY_CREATE}`: creates a directory at a specific path
        * `#{Action::DIRECTORY_DELETE}`: deletes a directory at a specific path
        * `#{Action::DIRECTORY_MOVE}`: moves a directory from one path to another
        * `#{Action::DIRECTORY_LIST}`: lists the contents of a directory at a specific path
        * `#{Action::FILE_CREATE}`: creates a file at a specific path
        * `#{Action::FILE_DELETE}`: deletes a file at a specific path
        * `#{Action::FILE_MOVE}`: moves a file from one path to another
        * `#{Action::FILE_READ}`: reads the contents of a file at a specific path
        * `#{Action::FILE_WRITE}`: writes the contents of a file at a specific path
        * `#{Action::FILE_REPLACE}`: replaces the contents of a file at a specific path
      TEXT

      parameter :path, :string, description: <<~TEXT
        A file or directory path that is required for the following actions:
        * `#{Action::DIRECTORY_CREATE}`
        * `#{Action::DIRECTORY_DELETE}`
        * `#{Action::DIRECTORY_MOVE}`
        * `#{Action::DIRECTORY_LIST}`
        * `#{Action::FILE_DELETE}`
        * `#{Action::FILE_READ}`
        * `#{Action::FILE_WRITE}`
        * `#{Action::FILE_REPLACE}`
      TEXT

      paramter :to, :string, description: <<~TEXT
        A file or directory path that is required for the following actions:
        * `#{Action::DIRECTORY_MOVE}`
        * `#{Action::FILE_MOVE}`
      TEXT

      # @param driver [Computer::Driver]
      def initialize(logger: Logger.new(IO::NULL))
        @logger = logger
        super()
      end

      # @param action [String]
      # @param path [String]
      # @param to [String]
      def execute(action:, path: nil, to: nil)
        @logger.info({
          action:,
          path:,
          to:,
        }.compact.map { |key, value| "#{key}=#{value.inspect}" }.join(" "))

        case action
        when Action::DIRECTORY_CREATE then Disk::DirectoryCreateTool.new(logger: @logger).execute(path:)
        when Action::DIRECTORY_DELETE then Disk::DirectoryDeleteTool.new(logger: @logger).execute(path:)
        when Action::DIRECTORY_MOVE then Disk::DirectoryMoveTool.new(logger: @logger).execute(path:, to:)
        when Action::DIRECTORY_LIST then Disk::DirectoryListTool.new(logger: @logger).execute(path:)
        when Action::FILE_CREATE then Disk::FileCreateTool.new(logger: @logger).execute(path:)
        when Action::FILE_DELETE then Disk::FileDeleteTool.new(logger: @logger).execute(path:)
        when Action::FILE_MOVE then Disk::FileMoveTool.new(logger: @logger).execute(path:, to:)
        when Action::FILE_READ then Disk::FileReadTool.new(logger: @logger).execute(path:)
        when Action::FILE_WRITE then Disk::FileWriteTool.new(logger: @logger).execute(path:)
        when Action::FILE_REPLACE then Disk::FileReplaceTool.new(logger: @logger).execute(path:)
        end
      end
    end
  end
end
