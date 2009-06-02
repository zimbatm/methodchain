require 'methodchain'

class MyClass
  extend MethodChain
  def mymeth; "hello" end
  chain_method :mymeth, "replace original"
  def mymeth; super + "world" end
end
MyClass.new.mymeth #=> "helloworld"
MyClass.ancestors 
#=> [MyClass, 
# #<MethodChain::Backup:0x614cc #mymeth,"replace original","/opt/local/lib/ruby/1.8/irb/workspace.rb:52:in `irb_binding'">, 
# Object, Kernel]
