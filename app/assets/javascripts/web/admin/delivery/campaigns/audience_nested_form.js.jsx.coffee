newForms = (component) ->
  forms = []
  audienceTypes = []
  $(component.props.audience_types).each ->
    if $.inArray(@[1], ['users', 'contact_emails']) == -1
      audienceTypes.push @
  for i in [0...component.state.newFieldsCount]
    forms.push `<AudienceForm index={i + component.props.audiences.length}
                              campaign_id={component.props.campaign_id}
                              audience_types={audienceTypes} />`
  forms

existedForms = (component) ->
  forms = []
  for i in component.props.audiences
    forms.push `<AudienceForm audience={this}
                              index={i + component.props.audiences.length}
                              campaign_id={component.props.campaign_id}
                              audience_types={component.props.audience_types} />`
  forms

addNewFieldsButton = (component) ->
  if component.state.addNewFieldsButtonStatus == 'visible'
    `<a href='#' className='btn btn-warning' onClick={component.addFields} >
      {I18n.t('web.admin.delivery.campaigns.form.add_audience')}
    </a>`

@AudienceNestedForm = React.createClass
  getInitialState: ->
    {
      newFieldsCount: 0
      audiences: this.props.audiences
      addNewFieldsButtonStatus: 'visible'
    }
  addFields: (e) ->
    e.preventDefault()
    this.setState { newFieldsCount: this.state.newFieldsCount + 1 }
  componentDidUpdate: ->
    if this.state.newFieldsCount + this.props.audiences.length == 1
      mainAudienceType = $('#delivery_campaign_audiences_attributes_0_audience_type').val()
      switch mainAudienceType
        when 'team', 'event_registrations'
          status = 'visible'
        when 'users', 'contact_emails'
          status = 'hidden'
      this.setState { addNewFieldsButtonStatus: status }
  render: ->
    `<div>
      {existedForms(this)}
      {newForms(this)}
      {addNewFieldsButton(this)}
    </div>`
