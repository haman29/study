require 'rubygems'
require 'rspec'
require '../src/muschemer.rb'

describe 'MuSchemeR' do
  describe '第１章 プログラムと評価' do
    before do
      @exp1 = [:+, 1, 2]
      @exp2 = [:-, 1, 2]
      @exp3 = [:-, 1, [:+, 2, 3]]
    end
    describe '_eval' do
      it { _eval(@exp1).should == 3  }
      it { _eval(@exp2).should == -1 }
      it { _eval(@exp3).should == -4 }
    end
    describe 'list?' do
      it { should_not be_list(1)}
      it { should be_list([1, 2, 3])}
    end
    describe 'immediate_val?' do
      # A
      it { immediate_val?(1).should be_true }
      it { immediate_val?('1').should be_false }

      # predicate を使う場合
      it { should be_immediate_val(1) }
      it { should_not be_immediate_val('1') }
    end
    describe 'car' do
      it { car(@exp1).should == :+ }
    end
    describe 'cdr' do
      it { cdr(@exp1).should == [1, 2] }
    end
    describe 'lookup_primitive_fun' do
      # lambdaのテストは失敗...
      # it { lookup_primitive_fun(:+).should == [:prim, lambda {|x, y| x + y}]}
      # it { lookup_primitive_fun(:-).should == [:prim, lambda {|x, y| x - y}]}
      # it { lookup_primitive_fun(:*).should == [:prim, lambda {|x, y| x * y}]}
    end
    describe 'eval_list' do
      it { eval_list(cdr(@exp1)).should == [1, 2] }
    end
  end
end
