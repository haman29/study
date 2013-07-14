# @see https://github.com/ichusrlocalbin/scheme_in_ruby

# 式(exp)を評価する
def _eval exp
  if not list?(exp)
    if immediate_val?(exp)
      exp
    else
      lookup_primitive_fun(exp)
    end
  else
    fun  = _eval(car(exp))
    args = eval_list(cdr(exp))
    apply(fun, args)
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

def lookup_primitive_fun exp
  $primitive_fun_env[exp]
end

# リストの要素それぞれを評価したものをリストにしたもの
def eval_list(exp)
  exp.map{ |e| _eval(e) }
end

def apply fun, args
  fun_val = fun[1]
  fun_val.call(*args)
end

$primitive_fun_env = {
    :+ => [:prim, lambda {|x, y| x + y}],
    :- => [:prim, lambda {|x, y| x - y}],
    :* => [:prim, lambda {|x, y| x * y}],
}
