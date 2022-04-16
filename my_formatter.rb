class MyFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_group_started, :start, :stop
  def initialize(output)
    @output = output
  end

  def start(notification)
    @output << "---\ntitle: Feedback on the assignment\n---\n"
  end

  def example_passed(notification)
    @output << "- ✅ #{notification.example.description}\n"
  end

  def example_group_started(notification)
    if notification.group.to_s.count(':') == 4
      @output << "# #{notification.group.description}\n"
    elsif notification.group.to_s.count(':') == 6
      @output << "## #{notification.group.description}\n"
    elsif notification.group.to_s.count(':') == 8
      @output << "### #{notification.group.description}\n"
    elsif notification.group.to_s.count(':') == 10
      @output << "###### #{notification.group.description}\n"
    end
  end

  def example_failed(notification)
    @output << "- [ ] ❌ #{notification.example.description}\n"
  end
  
  def stop(notification)
    if notification.examples.count == 0
      @output << "## Evaluation could not be performed. Please check for syntax errors in your code.\n### Common syntax errors\n- Typos in code.\n- The `end` is missing."
    end
  end
end
