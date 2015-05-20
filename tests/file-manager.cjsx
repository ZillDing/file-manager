Images = new FS.Collection 'images',
	stores: [new FS.Store.FileSystem 'images']

if Meteor.isClient
	FileManager = ReactMeteor.createClass
		templateName: 'FileManager'
		displayName: 'FileManager'
		startMeteorSubscriptions: ->
			Meteor.subscribe 'images'
		getMeteorState: ->
			data: Images.find().fetch()
		render: ->
			<ReactBootstrap.Grid>
				<ReactBootstrap.PageHeader>Meteor File Manager</ReactBootstrap.PageHeader>
				<FileUploader />
				<FileViewer data={@state.data} />
			</ReactBootstrap.Grid>

	FileUploader = React.createClass
		displayName: 'FileUploader'
		_changeFile: ->
			# upload the file
			file = @refs.fileInput.getInputDOMNode().files[0]
			Images.insert file, (err, fileObj) =>
				if err
					alert err
				else
					alert 'upload done!'
					@refs.fileInput.getInputDOMNode().value = '' # clear the input
		render: ->
			<ReactBootstrap.Input
				ref="fileInput"
				type="file"
				label="Upload a File"
				onChange={@_changeFile}>
			</ReactBootstrap.Input>

	FileViewer = React.createClass
		propTypes:
			data: React.PropTypes.array
		displayName: 'FileViewer'
		_createElement: (el) ->
			<File key={el._id} data={el} />
		render: ->
			<ReactBootstrap.Row>
				{_.map @props.data, @_createElement}
			</ReactBootstrap.Row>

	File = React.createClass
		propTypes:
			data: React.PropTypes.object.isRequired
		displayName: 'File'
		_deleteFile: ->
			Images.remove @props.data._id
		render: ->
			file = @props.data
			<ReactBootstrap.Col xs={6} md={3}>
				<ReactBootstrap.Thumbnail src={file.url()} alt="thumbnail">
					<h3>{file.name()}</h3>
					<p style={{margin: 0}}>
						<ReactBootstrap.Button
							bsStyle="danger"
							onClick={@_deleteFile}>
							Delete
						</ReactBootstrap.Button>
					</p>
				</ReactBootstrap.Thumbnail>
			</ReactBootstrap.Col>

if Meteor.isServer
	Meteor.publish 'images', ->
		Images.find()
