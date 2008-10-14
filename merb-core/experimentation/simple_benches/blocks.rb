require "rubygems"
require "rbench"

ARG = "Hello".freeze
PROC_OBJECT = Proc.new { |arg| }
PROC_METHOD = proc { |arg| }
PROC_LAMBDA = lambda { |arg| }

RBench.run(1_000_000) do
  column :proc_object
  column :proc_method
  column :proc_lambda
  
  report "using call" do
    proc_object { PROC_OBJECT.call(ARG) }
    proc_method { PROC_METHOD.call(ARG) }
    proc_lambda { PROC_LAMBDA.call(ARG) }
  end
  
  report "using brackets" do
    proc_object { PROC_OBJECT[ARG] }
    proc_method { PROC_METHOD[ARG] }
    proc_lambda { PROC_LAMBDA[ARG] }
  end
end

__END__

                       PROC_OBJECT | PROC_METHOD | PROC_LAMBDA |
----------------------------------------------------------------
using call                   1.019 |       0.997 |       1.097 |
using brackets               0.992 |       0.982 |       1.001 |


                       PROC_OBJECT | PROC_METHOD | PROC_LAMBDA |
----------------------------------------------------------------
using call                   1.006 |       0.983 |       0.979 |
using brackets               0.986 |       0.975 |       0.977 |