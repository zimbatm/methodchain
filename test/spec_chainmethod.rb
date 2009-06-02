require 'bacon'
require 'methodchain'

describe MethodChain do
  it "knows how to use super in a module" do
    m = Module.new do
      def m; "one" end
      extend MethodChain
      chain_method :m
      def m; super + "two" end
    end
    c = Class.new do include m end
    c.new.m.should == "onetwo"
  end
    
  it "knows how to use super in a class" do
    c = Class.new do
      def m; "one" end
      extend MethodChain
      chain_method :m
      def m; super + "two" end
    end
    c.new.m.should == "onetwo"
  end
  
  it "fails if the method does not exist" do
    m = Module.new
    m.extend MethodChain
    proc{ m.send(:chain_method, :xy) }.should.raise(NameError)
  end
    
  it "is not available from outside the class or module" do
    m = Module.new
    m.extend MethodChain
    proc{ m.chain_method(:xy) }.should.raise(NoMethodError)
  end
  
  it "also works with instances (not really useful)" do
    myobj = "hello"
    def myobj.to_s; self end
    myobj.extend MethodChain
    myobj.send(:chain_method, :to_s)
    def myobj.to_s; super + "world" end
    myobj.to_s.should == "helloworld"
  end
  
  it "keeps a method protected" do
    c = Class.new do
      def mymeth; end
      protected :mymeth
      extend MethodChain
      chain_method :mymeth
    end
    proc{ c.new.mymeth }.should.raise(NoMethodError)
  end
  
  it "keeps a method private" do
    c = Class.new do
      def mymeth; end
      protected :mymeth
      extend MethodChain
      chain_method :mymeth
    end
    proc{ c.new.mymeth }.should.raise(NoMethodError)
  end
  
  it "shows up nicely in the class's ancestors" do
    c = Class.new do
      def mymeth; end
      extend MethodChain
      chain_method :mymeth
    end
    c.included_modules.first.inspect.should =~ /#<MethodChain::Backup:0x[a-f\d]+ #mymeth/
  end
end

