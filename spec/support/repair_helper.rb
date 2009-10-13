# repair validate callbacks
# from active_record/test/cases/repair_helper.rb

def record_validations(*klasses)
  klasses.inject({}) do |repair, klass|
    repair[klass] ||= {}
    [ :validate, :validate_on_create, :validate_on_update ].each do |phase|
      callbacks = klass.instance_variable_get("@#{phase.to_s}_callbacks")
      repair[klass][phase] = (callbacks.nil? ? nil : callbacks.dup)
    end
    repair
  end
end

def reset_validations(repairs)
  repairs.each do |klass, repair|
    [ :validate, :validate_on_create, :validate_on_update ].each do |phase|
      klass.instance_variable_set("@#{phase.to_s}_callbacks", repair[phase])
    end
  end
end
