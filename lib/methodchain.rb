# See README.rdoc and MethodChain#chain_method
module MethodChain
  VERSION = "0.1.0"
  # This is the specialized module that will be included in your class.
  # See MethodChain#chain_method for more doc
  class Backup < Module
    def initialize(target, reason, from, &newmeth)
      @target, @reason, @from = target, (reason && reason.to_s), from
      super(&newmeth)
    end

    RE = />$/.freeze

    def inspect
      @reason ?
        super.sub(RE, " ##{@target},#{@reason.inspect},#{@from.inspect}>") :
        super.sub(RE, " ##{@target},#{@from.inspect}>") 
    end
  end

  # See MethodChain for introduction.
  #
  # +target+:: name of the method to be stashed
  # +reason+:: if given, will be print in the class ancestors's Backup module instance
  def chain_method(target, reason=nil)
    from = caller[1]
    
    mod = self.kind_of?(Module) ? self : (class << self; self end)
    
    visibility = case
    when mod.public_method_defined?(target) then :public
    when mod.protected_method_defined?(target) then :protected
    when mod.private_method_defined?(target) then :private
    else
      remove_method target # raises NameError
    end
    
    mod.module_eval do
      orig = instance_method(target)
      back = Backup.new(target, reason, from)
      include back
      back.module_eval do
        define_method(target, orig)
        if visibility == :protected || visibility == :private
          protected target
        end
      end
    end
  end
  protected :chain_method
end
