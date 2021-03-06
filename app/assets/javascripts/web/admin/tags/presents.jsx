import React from 'react'

class TagsPresents extends React.Component {
  removeTag(tag_id) {
    var component = this
    $.ajax({
      url: Routes.api_admin_tag_path(tag_id),
      type: 'DELETE',
      success: function() {
        component.props.reloadTags()
        // FIXME несмотря на ответ сервера success, здесь исполняется всё равно error
      },
      error: function() {
        component.props.reloadTags()
      }
    })
  }
  render() {
    var presents_tags = []
    var tags = this.props.tags
    var component = this
    $(tags).each(function(index) {
      presents_tags.push(<li key={index} className='list-group-item'>
          <a onClick={component.removeTag.bind(component, this.id)} className="badge tag_destroy" rel="nofollow">
            X
          </a>
          {this.text}
        </li>)
    })
    return(<ul className='list-group'>
      {presents_tags}
    </ul>)
  }
}

export default TagsPresents
