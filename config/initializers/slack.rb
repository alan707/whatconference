if Nenv.slack_webhook_url
  SLACK = Slack::Notifier.new Nenv.slack_webhook_url
else
  SLACK = Slack::DummyNotifier.new
end
