require 'rubygems'
require 'rspec'
require File.dirname(__FILE__) + '/../src/muschemer.rb'

describe 'MuSchemeR' do
  describe '第２章 関数適用の評価' do
    before do

      @lambda = [[:lambda, [:x, :y], [:+, :x, :y]], 3, 5]
      @lambda2 = [[:lambda, [:x],
                   [:+,
                    [[:lambda, [:x], :x], 2],
                   :x]],
                   1]
      @let = [:let, [[:x, 3]],
              [:let, [[:fun, [:lambda, [:y], [:+, :x, :y]]]],
               [:+, [:fun, 1], [:fun, 2]]]]
    end
    describe 'lookup_var' do
      it { lookup_var(:x, [{:x => 1}]).should == 1 }
      # TODO: 例外のテスト方法
      # it { lookup_var(:y, [{:x => 1}]).should raise_error(RuntimeError) }
    end
    describe 'extend_env' do
      parameters  = [:x, :y]  # keys
      args        = [1, 2]    # values
      current_env = [{:z=>4}] # current environment
      env         = extend_env(parameters, args, current_env)
      it { env.should == [{:x=>1, :y=>2}, {:z=>4}]}
      it { lookup_var(:x, env).should == 1}
      it { lookup_var(:y, env).should == 2}
      it { lookup_var(:z, env).should == 4}
    end
    describe 'let_to_parameters_args_body' do
      it { let_to_parameters_args_body([:let, [[:x, 3], [:y, 5]], [:+, :x, :y]]).should == [[:x, :y], [3, 5], [:+, :x, :y]] }
    end
    describe '_eval' do
      it do
        _eval(@lambda, $global_env).should == 8
        _eval(@lambda2, $global_env).should == 3 # 4ではない
        _eval(@let, $global_env).should == 9
      end
    end
    describe 'special_form?' do
      it { special_form?([:lambda, [:x, :y], [:+, :x, :y]]).should be_true }
      it { special_form?([:let, [[:x, 1], [:y, 2]], [:+, :x, :y]]).should be_true }
    end
  end
end
