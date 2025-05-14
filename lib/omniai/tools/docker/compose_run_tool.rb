# frozen_string_literal: true

require "open3"

module OmniAI
  module Tools
    module Docker
      # @example
      #   tool = OmniAI::Tools::Docker::ComposeRunTool.new(root: "./project")
      #   tool.execute(service: "app", command: "rspec" args: ["spec/main_spec.rb"])
      class ComposeRunTool < BaseTool
        description "Runs a command via Docker with arguments on the project (e.g. `rspec spec/main_spec.rb`)."

        parameter :service, :string, description: "The service to run the command on (e.g. `app`)."
        parameter :command, :string, description: "The command to run (e.g. `rspec`)."
        parameter :args, :array, description: "The arguments for the command.",
          items: OmniAI::Schema.string(description: "An argument for the command (e.g. `spec/main_spec.rb`).")

        # @param service [String]
        # @param command [String]
        # @param args [Array<String>]
        #
        # @return [String]
        def execute(command:, service: "app", args: [])
          @logger.info(%(#{self.class.name}#execute service="#{service}" command="#{command}" args=#{args.inspect}))

          Dir.chdir(@root) do
            capture!("docker", "compose", "run", "--build", "--rm", service, command, *args)
          rescue CaptureError => e
            @logger.info("ERROR: #{e.message}")
            return "ERROR: #{e.message}"
          end
        end
      end
    end
  end
end
