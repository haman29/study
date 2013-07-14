require 'rubygems'
require 'rspec'
require File.dirname(__FILE__) + '/../src/muschemer.rb'

describe 'MuSchemeR' do
  describe '第３章 再帰' do
    before do
      @fact = [:letrec,
               [[:fact,
                 [:lambda, [:n], [:if, [:<, :n, 1], 1, [:*, :n, [:fact, [:-, :n, 1]]]]]]],
               [:fact, 3]]
    end
    describe '_eval' do
      # it { _eval(@fact, $global_env).should ==  1*2*3}
    end
    describe 'eval_if' do
      it { eval_if([:if, [:>, 3, 2], 1, 0], $global_env).should == 1 }
      it { eval_if([:if, [:<, 3, 2], 1, 0], $global_env).should == 0 }
      it { eval_if([:if, [:>=, 3, 2], 1, 0], $global_env).should == 1 }
      it { eval_if([:if, [:<=, 3, 2], 1, 0], $global_env).should == 0 }
      it { eval_if([:if, [:==, 3, 2], 1, 0], $global_env).should == 0 }
    end
  end
end
