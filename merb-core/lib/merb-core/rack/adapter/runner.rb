module Merb
  
  module Rack
    
    class Runner
      # ==== Parameters
      # opts<Hash>:: Options for the runner (see below).
      #
      # ==== Options (opts)
      # :runner_code<String>:: The code to run.
      #
      # ==== Notes
      # If opts[:runner_code] matches a filename, that file will be read and
      # the contents executed. Otherwise the code will be executed directly.
      #
      # :api: plugin
      def self.start(opts={})
        Merb::Server.change_privilege

        if opts[:runner_code]
          runner_code = opts[:runner_code]
          if File.exists?(opts[:runner_code])
            runner_code = File.read(runner_code)
            runner_script = true
          end

          begin
            eval(runner_code, TOPLEVEL_BINDING, __FILE__, __LINE__)
          rescue Exception => e
            # check to see if user gave us a string that links like they tried to run a script file
            if !runner_script && (runner_code.include?(File::SEPARATOR) || runner_code.include?(".rb"))
              Merb.logger.error!("Merb Runner Adapter - tried to execute script file")
              Merb.logger.error!("Not Found: #{runner_code}")
            else
              raise e
            end
          end
          exit
        end  
      end
    end
  end
end
