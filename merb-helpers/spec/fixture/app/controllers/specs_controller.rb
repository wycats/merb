class SpecController < Merb::Controller
  layout nil
end

# Forms, FieldSets, and Labels
class FormSpecs < SpecController ; end
class FormForSpecs < SpecController ; end
class FieldsForSpecs < SpecController ; end
class FieldsetSpecs < SpecController ; end
class LabelSpecs < SpecController ; end

# Text fields
class TextFieldSpecs < SpecController ; end
class BoundTextFieldSpecs < SpecController ; end

# Passwords
class PasswordFieldSpecs < SpecController ; end
class BoundPasswordFieldSpecs < SpecController ; end

# TextAreas
class TextAreaSpecs < SpecController ; end
class BoundTextAreaSpecs < SpecController ; end

# Checkboxes
class CheckBoxSpecs < SpecController ; end
class BoundCheckBoxSpecs < SpecController ; end

# Hidden Fields
class HiddenFieldSpecs < SpecController ; end
class BoundHiddenFieldSpecs < SpecController ; end

# Radio Buttons
class RadioButtonSpecs < SpecController ; end
class BoundRadioButtonSpecs < SpecController ; end
class RadioGroupSpecs < SpecController ; end
class BoundRadioGroupSpecs < SpecController ; end

# Selects and Options
class SelectSpecs < SpecController ; end
class BoundSelectSpecs < SpecController ; end
class OptionTagSpecs < SpecController ; end
class BoundOptionTagSpecs < SpecController ; end

# Files
class FileFieldSpecs < SpecController ; end
class BoundFileFieldSpecs < SpecController ; end

# Buttons and Inputs
class SubmitSpecs < SpecController ; end
class ButtonSpecs < SpecController ; end
class DeleteButtonSpecs < SpecController ; end

# Custom builders
class CustomBuilderSpecs < SpecController ; end 
