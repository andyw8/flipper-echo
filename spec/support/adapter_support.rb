# encoding: utf-8
#
module AdapterSupport
  def adapter_class
    @adapter_class ||= Class.new do
      %w(remove clear enable disable).each do |method|
        define_method(method) { |*_args| }
      end
    end
  end
end
