require 'ansi/code'

module Minitest
  module Reporters

    class NutrioReporter < DefaultReporter
      if defined?(Rails)
        # display rerun line for failures if on Rails
        class_attribute :executable
        self.executable = "bin/rails test"
      end

      def on_report
        status_line = "Finished in %s, %.1f tests/s, %.1f assertions/s." %
          [
            Time.at(total_time).utc.strftime("%Hh %Mm %Ss"),
            count / total_time,
            assertions / total_time
          ]

        puts
        puts
        puts colored_for(suite_result, status_line)

        if @slow_count > 0
          slow_tests = tests.sort_by(&:time).reverse.take(@slow_count)

          puts
          puts "Slowest tests:"
          puts

          slow_tests.each do |test|
            puts "%.6fs %s" % [test.time, "#{test.name}##{test.class}"]
          end
        end

        if @slow_suite_count > 0
          slow_suites = @suite_times.sort_by { |x| x[1] }.reverse.take(@slow_suite_count)

          puts
          puts "Slowest test classes:"
          puts

          slow_suites.each do |slow_suite|
            puts "%.6fs %s" % [slow_suite[1], slow_suite[0]]
          end
        end

        puts
        print colored_for(suite_result, result_line)
        puts
      end

      def on_record(test)
        print "#{"%.2f" % test.time} = " if options[:verbose]

        # Print the pass/skip/fail mark
        output = if test.passed?
          record_pass(test)
        elsif test.skipped?
          record_skip(test)
        elsif test.failure
          "#{record_failure(test)}\n#{failure_message(test)}\n"
        end

        print(output)
      end

      def failure_message(test)
        message = message_for(test)
        unless message.nil? || message.strip == ''
          message = "\n#{colored_for(result(test), message)}\n\n#{format_rerun_snippet(test)}"
        end
        message
      end

      private

      def app_root
        @app_root ||= defined?(ENGINE_ROOT) ? ENGINE_ROOT : Rails.root
      end

      def relative_path_for(file)
        file.sub(/^#{app_root}\/?/, '')
      end

      def format_rerun_snippet(result)
        return '' unless defined?(Rails)
        location, line = result.method(result.name).source_location
        "\n#{self.executable} #{relative_path_for(location)}:#{line}\n"
      end
    end

  end
end
