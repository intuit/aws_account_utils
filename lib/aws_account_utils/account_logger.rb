require 'logger'
require 'forwardable'

module AwsAccountUtils
  class AccountLogger
    extend Forwardable
    def_delegators :@logger, :fatal, :debug, :error, :info, :warn, :debug?

    def initialize(log_level)
      @log_level = log_level
      @logger = new_logger
    end

    private
    def new_logger
      STDOUT.sync = true
      Logger.new(STDOUT).tap do |l|
        l.datetime_format = '%Y-%m-%dT%H:%M:%S%z'
        l.formatter = proc do |severity, datetime, progname, msg|
          "#{datetime} #{severity} : #{msg}\n"
        end
        l.level = Logger.const_get @log_level.upcase
      end
    end
  end
end
