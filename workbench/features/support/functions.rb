# EPBT - SAP Enterprise Portal Behavior Testing
# http://github.com/arnaud/EPBT  -  MIT License

#
# Helper functions
#

def times_to_i(times)
  case times
  when "first"
    pos = 1
  when "second"
    pos = 2
  when "third"
    pos = 3
  when "fourth"
    pos = 4
  when "fifth"
    pos = 5
  when "sixth"
    pos = 6
  when "seventh"
    pos = 7
  when "eighth"
    pos = 8
  when "nineth"
    pos = 9
  when "tenth"
    pos = 10
  else
    fail("Not implemented: times_to_i(\"#{times}\")")
  end
end

def find_textfield_by_name(name)
  @portal.app.text_field(:id, find_element_id_by_label_name(name))
end

def find_checkbox_by_name(name)
  @portal.app.checkbox(:id, find_element_id_by_label_name(name))
end

def find_textview_by_name(name)
  @portal.app.span(:id, find_element_id_by_label_name(name))
end

def find_table_by_id(id)
  @portal.app.cell(:id, /.+#{Regexp.escape(id)}\-content/).table(:class, /ur.*dF/)
end

private

def find_element_id_by_label_name(name)
  label_regexp = Regexp.new(name + "\s?\:?")
  l = @portal.app.label(:text, label_regexp)
  id = l.attribute_value('f')
  id
end
