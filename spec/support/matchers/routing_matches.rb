RSpec::Matchers.define :route_to do |expected|
  match do |actual|
    actual.route.should_not be_nil
    actual.route.block.call.should == expected
  end

  failure_message_for_should do |actual|
    message = "expected route to #{expected} but got "
    message << (actual.route.nil? ? "no match" : "#{actual.route.block.call}")
  end

  description do
    "route to #{expected}"
  end
end

RSpec::Matchers.define :have_matches do |expected|
  match do |actual|
    actual.matches.should_not be_nil
    actual.matches.to_hash.should == expected
  end

  failure_message_for_should do |actual|
    message = "expected matches #{expected.inspect} but got "
    message << (actual.matches.nil? ? "no match" : "#{actual.matches.inspect}")
  end

  description do
    "have matches #{expected.inspect}"
  end
end
