# @see https://github.com/ichusrlocalbin/scheme_in_ruby

# 演算子の定義
$primitive_fun_env = {
    :+ => [:prim, lambda {|x, y| x + y}],
    :- => [:prim, lambda {|x, y| x - y}],
    :* => [:prim, lambda {|x, y| x * y}],
    :> => [:prim, lambda {|x, y| x > y}],
    :< => [:prim, lambda {|x, y| x < y}],
    :>= => [:prim, lambda {|x, y| x >= y}],
    :<= => [:prim, lambda {|x, y| x <= y}],
    :== => [:prim, lambda {|x, y| x <= y}],
}
$global_env = [$primitive_fun_env]

# 式(exp)を評価する
def _eval(exp, env)
  if not list?(exp)
    if immediate_val?(exp)
      exp
    else
      lookup_var(exp, env)
    end
  else
    if special_form? exp
      eval_special_form exp, env
    else
      fun  = _eval(car(exp), env)
      args = eval_list(cdr(exp), env)
      apply(fun, args)
    end
  end
end

# 配列のインスタンスかどうかで関数か式かを判別する
def list?(exp)
  exp.is_a?(Array)
end

# 数値をそのまま数値で返す
def immediate_val?(exp)
  num?(exp)
end

# 受け取った式がNumericかどうか
def num?(exp)
  exp.is_a?(Numeric)
end

# リストの先頭の要素を取得
def car list
  list[0]
end

# リストの先頭要素移行のリストを取得する
def cdr list
  list[1..-1]
end

# 関数の中身を取得する
def lookup_primitive_fun exp
  $primitive_fun_env[exp]
end

# リストの要素それぞれを評価したものをリストにしたもの
def eval_list(exp, env)
  exp.map{ |e| _eval(e, env) }
end

# primitiveとは:+, :-などのこと
def apply_primitive_fun fun, args
  fun_val = fun[1]
  fun_val.call(*args)
end

# 関数適用する
def apply fun, args
  if primitive_fun?(fun)
    apply_primitive_fun(fun, args)
  else
    lambda_apply(fun, args)
  end
end

def primitive_fun? exp
  exp[0] == :prim
end

# 指定した変数が束縛している値を取得する
def lookup_var var, env
  target_env = env.find{ |alist| alist.key?(var) }
  raise "couldn't find value to valiables:'#{var}'" unless target_env
  target_env[var]
end

# 環境の拡張 (変数の束縛をハッシュで表現する)
def extend_env parameters, args, env
  h = {}
  parameters.zip(args).each{ |k, v| h[k] = v}
  [h] + env
end

# let式
def eval_let exp, env
  parameters, args, body = let_to_parameters_args_body exp
  # lambda式に変換
  lambda_exp = [[:lambda, parameters, body]] + args
  _eval(lambda_exp, env)
end
def let_to_parameters_args_body exp
  [exp[1].map{|e| e[0]}, exp[1].map{|e| e[1]}, exp[2]]
end
def let? exp
  exp[0] == :let
end

# lambda式
def eval_lambda exp, env
  make_closure exp, env
end
# closureとはlambda式とenviromnent(環境)のペアのこと
def make_closure exp, env
  parameters, body = exp[1], exp[2]
  [:closure, parameters, body, env]
end
def lambda_apply closure, args
  parameters, body, env = closure_to_parameters_body_env closure
  new_env = extend_env parameters, args, env
  _eval(body, new_env)
end
def closure_to_parameters_body_env closure
  [closure[1], closure[2], closure[3]]
end
def lambda? exp
  exp[0] == :lambda
end

# lambda式 or let式
def special_form? exp
  lambda?(exp) or
  let?(exp) or
  if?(exp)
end

def eval_special_form exp, env
  return eval_lambda exp, env if lambda? exp
  return eval_let exp, env    if let? exp
  return eval_if exp, env     if if? exp
end

# 第3章 再帰
def eval_if exp, env
  cond, true_clause, false_clause = if_to_cond_true_false exp
  if _eval cond, env
    _eval true_clause, env
  else
    _eval false_clause, env
  end
end
def if_to_cond_true_false exp
  [exp[1], exp[2], exp[3]]
end
def if? exp
  exp[0] == :if
end
