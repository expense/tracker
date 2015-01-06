
RSpec::Matchers.define :be_command do |command, params|
  match do |actual|
    actual_params = actual.parsed_params
    actual.command.to_s == command.to_s and
      params.all? { |k, v| actual_params[k] == v }
  end
  failure_message do |actual|
    "expected that [#{actual.command} #{actual.parsed_params}] would be " +
      "[#{command}, #{params}]"
  end
end
