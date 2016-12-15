require 'ansi/code'

module Minitest
  module Reporters

    class NutrioReporter < DefaultReporter
      def on_report
        super
        status_line = "Finished tests in %s, %.1f tests/s, %.1f assertions/s." %
          [ameliorated_time_string(total_time), count / total_time, assertions / total_time]

        puts
        puts colored_for(suite_result, status_line)
      end

      private

      def ameliorated_time_string(seconds)
        hours = seconds / 3600
        mins  = seconds / 60 % 60
        secs  = seconds % 60
        [
          hours >= 1 ? ("%.0dh" % hours) : nil,
          mins  >= 1 ? ("%.0dm" % mins) : nil,
          "%.0fs" % secs
        ].join(' ').strip
      end
    end

  end
end
