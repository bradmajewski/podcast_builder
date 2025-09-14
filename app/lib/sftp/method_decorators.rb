module SFTP
  # These are borrowed from python. You use it as `operation def start`
  # This works because the def keyword returns the method name as a symbol.
  # You need to use extend, not include. These do not work on class methods.
  module MethodDecorators
    module Client
      # Records method calls to the log and wraps SSH/SFTP exceptions with SFTP::Error
      def operation(symbol)
        original = instance_method(symbol)
        define_method(symbol) do |*args, **kwargs, &block|
          info("#{symbol}(#{args.map(&:inspect).join(", ")})")
          begin
            original.bind(self).call(*args, **kwargs, &block)
          rescue => e
            exception(e)
            raise #Error.from(e, @log)
          end
        end
      end
    end
  end
end
