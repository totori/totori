# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Helper functions
#

def find_cell_by_name(name)
  @portal.app.cell(:id, find_cell_id_by_label_name(name))
end

def find_textfield_by_name(name)
  @portal.app.text_field(:id, find_cell_id_by_label_name(name))
end

def find_checkbox_by_name(name)
  @portal.app.checkbox(:id, find_cell_id_by_label_name(name))
end

def find_textview_by_name(name)
  @portal.app.span(:id, find_cell_id_by_label_name(name))
end

private

def find_cell_id_by_label_name(name)
  label_regexp = Regexp.new(name + "\s?\:?")
  l = @portal.app.label(:text, label_regexp)
  id = l.attribute_value('f')
  id
end
