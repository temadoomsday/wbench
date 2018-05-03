module WBench
  class Browser
    attr_accessor :url, :driver

    def initialize(url, options = {})
      @driver = init_or_register_driver(options)

      @url           = Addressable::URI.parse(url).normalize.to_s
      @cookie_string = options[:cookie]
    end

    def visit
      set_cookies
      session.visit(url)
      wait_for_page
      session.execute_script(wbench_javascript)
      yield if block_given?
    ensure
      close
    end

    def evaluate_script(script)
      session.evaluate_script(script)
    end

    def run(&blk)
      session.instance_eval(&blk) if block_given?
    end

    private

    def add_selenium_args(options, arg)
      options[:args] ||= [ ]
      options[:args] << arg
    end

    def session
      @session ||= Capybara::Session.new(driver)
    end

    def close
      session.driver.browser.quit if session.driver.browser
      @session = nil
    end

    def wbench_javascript
      return @script if @script

      directory = File.expand_path(File.dirname(__FILE__)) + '/../javascripts'
      wbench    = File.open(File.join(directory, 'wbench.js'))
      @script   = wbench.read
    end

    def wait_for_page
      Selenium::WebDriver::Wait.new(timeout: WBench.capybara_timeout).until do
        session.evaluate_script('window.performance.timing.loadEventEnd').to_i > 0
      end
    end

    def set_cookies
      WBench::Cookies.set(session, url, @cookie_string)
    end

    def init_or_register_driver(options)
      return options[:driver] if options.key?(:driver)

      register_driver(options)
      WBench.capybara_driver
    end

    def register_driver(options)
      Capybara.register_driver(WBench.capybara_driver) do |app|
        http_client         = Selenium::WebDriver::Remote::Http::Default.new
        http_client.timeout = WBench.capybara_timeout
        browser             = (options[:browser] || DEFAULT_BROWSER).to_sym
        selenium_options    = { browser: browser, http_client: http_client }

        if options[:user_agent]
          if browser == :firefox
            profile = Selenium::WebDriver::Firefox::Profile.new
            profile['general.useragent.override'] = options[:user_agent]
            selenium_options[:profile] = profile
          else
            add_selenium_args(selenium_options, "--user-agent='#{options[:user_agent]}'")
          end
        end

        SeleniumDriver.new(app, selenium_options)
      end
    end
  end
end
