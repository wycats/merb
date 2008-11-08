##
## $Rev: 77 $
## $Release: 2.6.2 $
## copyright(c) 2006-2008 kuwata-lab.com all rights reserved.
##

module Erubis


  ##
  ## base error class
  ##
  class ErubisError < StandardError
  end


  ##
  ## raised when method or function is not supported
  ##
  class NotSupportedError < ErubisError
  end


end
