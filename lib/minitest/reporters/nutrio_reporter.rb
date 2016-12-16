require 'ansi/code'

module Minitest
  module Reporters

    class NutrioReporter < DefaultReporter
      def on_report
        super
        status_line = "Finished tests in %s, %.1f tests/s, %.1f assertions/s." %
          [
            Time.at(total_time).utc.strftime("%Hh %Mm %Ss"),
            count / total_time,
            assertions / total_time
          ]

        puts
        puts colored_for(suite_result, status_line)
      end
    end

  end
end
