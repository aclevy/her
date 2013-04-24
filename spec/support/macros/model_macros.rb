module Her
  module Testing
    module Macros
      module ModelMacros
        def find_model(name, options = {})
          parts = name.to_s.split(/::/).map(&:to_sym)
          options.fetch(:pop, 0).times { parts.pop }

          parts.inject(Object) do |parent_module, next_constant|
            if parent_module
              if parent_module.const_defined?(next_constant)
                parent_module.const_get(next_constant)
              elsif options[:create]
                Module.new.tap { |m| parent_module.const_set(next_constant, m) }
              end
            end
          end
        end

        def find_model_base(name, options = {})
          find_model name, options.merge(:pop => 1)
        end

        # Create a class and automatically inject Her::Model into it
        def spawn_model(klass, super_class = Object, &block)
          klass = klass.to_s
          super_class = find_model(super_class) unless super_class.is_a? Class
          model_name = klass.split(/::/).last

          find_model_base(klass, :create => true).module_eval do
            remove_const model_name if constants.map(&:to_s).include?(model_name)
            model = const_set(model_name, Class.new(super_class))
            model.send :include, Her::Model
            model.class_eval(&block) if block_given?
          end

          @spawned_models << klass.split(/::/).first.to_sym
        end

        def clear_spawned_models
          @spawned_models.each do |model|
            Object.instance_eval { remove_const model } if Object.const_defined?(model)
          end
        end
      end
    end
  end
end
