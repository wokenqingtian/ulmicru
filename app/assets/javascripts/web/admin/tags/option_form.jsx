formDisplay = function(component) {
  if (component.props.tagType == 'none') {
    return 'none'
  } else {
    return 'block'
  }
}

init_select2 = function(component) {
  $('.select2-tags').each(function() {
    if (component.props.tagType == 'string') {
      dataType = 'string'
    } else {
      dataType = component.props.targetType
    }
    if ($(this).hasClass(dataType)) {
      url = ''
      switch(dataType) {
        case 'string':
          url = Routes.api_admin_tags_path()
        case 'member':
          url = Routes.api_admin_members_path()
        case 'event':
          url = Routes.api_admin_events_path()
        case 'team':
          url = Routes.api_admin_teams_path()
        case 'activity_line':
          url = Routes.api_admin_activity_lines_path()
      }
      $(this).select2({
        ajax: {
          url: url,
          data: function(term, page) {
            return {
              q: term,
              page: page
            }
          },
          dataType: 'json',
          delay: 250,
          processResults: function(data) {
            tags_results = []
            $(data).each(function() {
              switch(dataType) {
                case 'string':
                  tags_results.push({
                    id: this.text,
                    text: this.text
                  })
                case 'member':
                  tags_results.push({
                    id: this.id,
                    text: `${this.ticket} | ${this.first_name} ${this.last_name}`
                  })
                case 'event', 'team', 'activity_line':
                  tags_results.push({
                    id: this.id,
                    text: this.title
                  })
              }
            })
            return({
              results: tags_results
            })
          }
        },
        minimumInputLength: 2
      })
    }
  })
}

formDisplay = function(component) {
  if (component.props.tagType == 'none') {
    return 'none'
  } else {
    return 'block'
  }
}

targetTypeInput = function(component) {
  if (component.props.targetType == 'none') {
    targetType = component.props.targetType.camelize()
    return(`<div className='input hidden tag_target_type'>
        <input className='hidden' type='hidden' name='tag[target_type]' id='tag_target_type' value={targetType} />
      </div>)
  }
}

hiddenInputs = function(component) {
  recordType = component.props.recordType.camelize()
  return(<div>
    <div className='input hidden tag_tag_type'>
      <input className='hidden' type='hidden' name='tag[tag_type]' id='tag_tag_type' value={component.props.tagType} />
    </div>
    <div className='input hidden tag_record_type'>
      <input value='News' className='hidden' type='hidden' name='tag[record_type]' id='tag_record_type' value={recordType} />
    </div>
    <div className='input hidden tag_record_id'>
      <input value={component.props.record.id} className='hidden' type='hidden' name='tag[record_id]' id='tag_record_id' />
    </div>
    {targetTypeInput(component)}
  </div>)
}

tagSelectDisplay = function(targetType, type, component) {
  if (targetType == type) {
    return 'block'
  } else {
    return 'none'
  }
}

linkSelect = function(type) {
  classes = `select optional select2-tags ${type}`
  return(<div className='input select optional tag_target_id'>
    <select className={classes} name='tag[target_id]' id='tag_target_id' data-type={type} style={{width: '100%'}}/>
  </div>)
}

getSelectToView = function(component) {
  switch(component.props.tagType) {
    case 'string':
      if (component.state.stringInputVisible == 'hidden') {
        return(<div className='input select optional tag_text'>
          <select className='select optional select2-tags string' name='tag[text]' id='tag_text' data-type='string' style={{width: '100%'}}/>
        </div>)
      }
    case 'link':
      linkSelect(component.props.targetType)
  }
}

newStringTagInput = function(component) {
  if ((component.props.tagType == 'string') && (component.state.stringInputVisible == 'visible')) {
    return(<div className='input text'>
      <input className='form-control input text' name='tag[text]' id='tag_text' />
    </div>)
  }
}

newStringTagButton = function(component) {
  if (component.props.tagType == 'string') {
    return(<a onClick={component.stringTagForm} className='btn btn-xs btn-warning' id='add_new_string_tag' href='#'>Создать новый</a>)
  }
}

class TagOptionForm extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      stringInputVisible: 'hidden',
      targetId: ''
    }
  }
  changeValue(inputId) {
    this.setState { targetId: $("##{inputId}").val() }
  }
  stringTagForm(e) {
    e.preventDefault()
    if (this.state.stringInputVisible == 'visible') {
      this.setState(){ stringInputVisible: 'hidden' })
    } else {
      this.setState(){ stringInputVisible: 'visible' })
    }
  }
  componentDidUpdate() {
    init_select2(this)
    component = this
    $('.tag_form').on('ajax:success', component.props.onTagSubmit)
  }
  render() {
    display = formDisplay this
    return(<form className='tag_form' action={Routes.api_admin_tags_path()} onSubmit={this.props.onTagSubmit} data-remote='true' method='post' style={{display}}>
      {hiddenInputs(this)}
      {getSelectToView(this)}
      {newStringTagInput(this)}
      <input type='submit' name='commit' value='Добавить тег' className='button btn btn-xs btn-success' />
      {newStringTagButton(this)}
    </form>)
  }
}
