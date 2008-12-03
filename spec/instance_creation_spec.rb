require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require "statement_executor"

describe StatementExecutor do
  before do
    @caller = StatementExecutor.new
  end

  it "can create an instance" do
    response = @caller.create("x", "TestModule.TestSlim",[])
    response.should == "OK"
    x = @caller.instance("x")
    x.class.name.should == "TestModule::TestSlim"
  end

  it "can create an instance with arguments" do
    response = @caller.create("x", "TestModule.TestSlimWithArguments", ["3"])
    response.should == "OK"
    x = @caller.instance("x")
    x.arg.should == "3"
  end

  it "can't create an instance with the wrong number of arguments" do
    result = @caller.create("x", "TestModule.TestSlim", ["noSuchArgument"])
    result.should include(Statement::EXCEPTION_TAG + "message:<<COULD_NOT_INVOKE_CONSTRUCTOR TestModule::TestSlim[1]>>")
  end

  it "can't create an instance if there is no class" do
    result = @caller.create("x", "TestModule.NoSuchClass", [])
    result.should include(Statement::EXCEPTION_TAG + "message:<<COULD_NOT_INVOKE_CONSTRUCTOR test_module/no_such_class>>")
  end
end