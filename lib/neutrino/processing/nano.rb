require 'shellwords'

module Neutrino
  module Processing
    module Nano
      attr_accessor :cached

      def convert!(format)
        pathname = converted_pathname(format)

        manipulate!('-format', format)

        if pathname != File.expand_path(cached.path)
          File.delete(cached)

          self.cached = File.open(pathname)
        end
      end

      def resize!(dimensions)
        manipulate!('-resize', dimensions)
      end

      def manipulate!(*arguments)
        pid = Kernel.spawn(build_command(arguments))

        Process.wait(pid)
      end

      private

      def build_command(arguments)
        Shellwords.join(['mogrify'] + arguments + [cached.path])
      end

      def converted_pathname(format)
        File.expand_path(cached.path.sub(/(\.\w*)?$/, ".#{format}"))
      end
    end
  end
end
