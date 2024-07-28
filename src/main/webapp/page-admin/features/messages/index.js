$(document).ready(function () {

	var $pagination = $('#postsPagination');
	var inpSearchPostsName = '';
	// Init twbsPagination with defaultOpts /assets/global.settings.js)
	$pagination.twbsPagination(defaultOpts);

	// Listener event onChange when user typing on input search.
	this.onSearchByName = function () {
		// Get value from input search.
		inpSearchPostsName = $('#inpSearchPostsName').val();
		// Call function search filter value from input.
		this.getPosts(0, defaultPageSize, inpSearchPostsName);
	}

	// Function search and pagination Posts. 
	this.getPosts = function (page = 0, size = defaultPageSize, name = '') {
		// Use Ajax call API search posts (/assets/http.js).
		Http.get(`${domain}/admin/api/messages?type=filter&page=${page}&size=${size}&name=${name}`)
			.then(res => {
				let appendHTML = '';
				// Clear all elements in table content.
				$('#tblPosts').empty();
				// Reset pagination.
				$pagination.twbsPagination('destroy');
				// Check api error or no data response.
				if (!res.success || res.data.totalRecord === 0) {
					// Append text No Data when records empty;
					$('#tblPosts').append(`<tr><td colspan='9' style='text-align: center;'>No Data</td></tr>`);
					// End function.
					return;
				}

				// Build table content from data responses.
				for (const record of res.data.records) {
					const createdDate = new Date(record.createdDate);
					const timeAgoString = timeAgo(createdDate);

					appendHTML += '<tr>';
					appendHTML += `<td>${record.id}</td>`;
					appendHTML += `<td>${record.email}</td>`;
					appendHTML += `<td>${record.subject}</td>`;
					appendHTML += `<td>${record.message}</td>`;
					appendHTML += `<td>${timeAgoString}</td>`;

					// Append action button Edit & Delete.
					appendHTML +=
						`<td class='text-right'>
                        <a class='btn btn-danger btn-sm' onclick='deletePosts(${record.id})'>
                            <i class='fas fa-trash'></i>
                        </a>
                    </td>`;
					appendHTML += '</tr>';
				}

				// Build pagination with twbsPagination.
				$pagination.twbsPagination($.extend({}, defaultOpts, {
					startPage: res.data.page + 1,
					totalPages: Math.ceil(res.data.totalRecord / res.data.size)
				}));
				// Add event listener when page change.
				$pagination
					.on('page', (event, num) => {
						this.getPosts(num - 1, defaultPageSize, inpSearchPostsName);
					});

				// Append html table into tBody.
				$('#tblPosts').append(appendHTML);
			})
			.catch(err => {
				toastr.error(err.errMsg);
			});
	}


	// Function delete posts by id.
	this.deletePosts = function (id) {
		// Use Ajax call API get posts by id (/assets/http.js).
		if (confirm("Do you want to delete this massage?")) {

			Http.delete(`${domain}/admin/api/messages?id=${id}`)
				.then(res => {
					if (res.success) {
						this.swicthViewPosts(true);
						toastr.success('Delete successfully!')
					} else {
						toastr.error(res.errMsg);
					}
				})
				.catch(err => {
					toastr.error(err.errMsg);
				});
		} else {
			// If don't confirm cancel
			toastr.warning('Canceled');
		}
	}

	// Call API get posts by id.
	this.getPostsById = function (id) {
		// Use Ajax call API get posts by id (/assets/http.js).
		Http.get(`${domain}/admin/api/messages?type=getOne&id=${id}`)
			.then(res => {
				if (res.success) {
					// Set value from response on update form.
					$('#inpPostsId').val(id);
					$('#inpPostsTitle').val(res.data.subject);
					$('#inpEmailTitle').val(res.data.email);
					$('#inpMessageTitle').val(res.data.messages);

					// Set value for box selects category.
					// More detail: https://select2.org/programmatic-control/add-select-clear-items			

					// Set value for textarea Content.
					// More detail: https://summernote.org/getting-started/#get--set-code

				} else {
					toastr.error(res.errMsg);
				}
			})
			.catch(err => {
				toastr.error(err.errMsg);
			})
	}

	// Function create/edit posts.
	this.savePosts = function () {
		const currentId = $('#inpPostsId').val();
		// Get value from input and build a JSON Payload.
		const payload = {
			'position': $('#inpPostsTitle').val(),
			'width': $('#inpWidthTitle').val(),
			'height': $('#inpHeightTitle').val(),
			'url': $('#inpUrlTitle').val()
		}
		// Create FormData and append files & JSON stringify.
		// More detail: https://viblo.asia/p/upload-file-ajax-voi-formdata-LzD5dL2e5jY
		// More detail with Postman: https://stackoverflow.com/questions/16015548/how-to-send-multipart-form-data-request-using-postman
		var formData = new FormData();
		// Append file selected from input.
		if ($('#inpPostsBanner')[0]) {
			formData.append('images', $('#inpPostsBanner')[0].files[0]);
		}
		// Append payload posts info.
		formData.append('payload', JSON.stringify(payload));
		if (currentId) {
			// Read detail additional function putFormData in file: /assets/http.js
			Http.putFormData(`${domain}/admin/api/messages?id=${currentId}`, formData)
				.then(res => {
					if (res.success) {
						this.swicthViewPosts(true);
						toastr.success(`Update posts success !`)
					} else {
						toastr.error(res.errMsg);
					}
				})
				.catch(err => {
					toastr.error(err.errMsg);
				});
		} else {
			// Read detail additional function postFormData in file: /assets/http.js
			Http.postFormData(`${domain}/admin/api/messages`, formData)
				.then(res => {
					if (res.success) {
						this.swicthViewPosts(true);
						toastr.success(`Create posts success !`)
					} else {
						toastr.error(res.errMsg);
					}
				})
				.catch(err => {
					toastr.error(err.errMsg);
				});
		}
	};
	// TODO: Handle after.
	this.draftPosts = function () {
		alert("Làm biếng chưa có code");
	}
	// Using select2 query data categories.
	// More detail: https://select2.org/data-sources/ajax
	this.initSelect2Category = function () {
		// Init value for select2 on id #selPostsCategory.
		$('#selPostsCategory').select2({
			theme: 'bootstrap4',
			// Call api search category with select2.
			ajax: {
				url: `${domain}/admin/api/category`,
				headers: {
					// Get token from localStore and append on API.
					// Read more function: /assets/http.js
					'Authorization': 'Bearer ' + Http.getToken(),
					'Content-Type': 'application/json',
				},
				data: function (params) {
					var query = {
						type: 'filter',
						page: 0,
						size: 10,
						// params.term is value input on select2.
						name: params.term
					}
					// Query parameters will be ?type=[type]&page=[page]&size=[size]&name=[params.term]
					return query;
				},
				// Transform the data returned by your API into the format expected by Select2
				// Default format when use select2 is [{id: [id], text: [text]}]
				// So we need convert data from response to format of select2.
				processResults: function (res) {
					return {
						// Why we need using function [map] ?
						// Read more: https://viblo.asia/p/su-dung-map-filter-va-reduce-trong-javascript-YWOZrxm75Q0 
						results: res.data.records.map(elm => {
							return {
								id: elm.id,
								text: elm.name
							}
						})
					};
				}
			}
		});
	}

	// Action change display screen between Table and Form Create/Edit.
	this.swicthViewPosts = function (isViewTable, id = null) {
		if (isViewTable) {
			$('#posts-table').css('display', 'block');
			$('#posts-form').css('display', 'none');
			this.getPosts(0, defaultPageSize);
		} else {
			// Init summernote (Text Editor).
			$('#inpPostContent').summernote({ height: 150 });
			// Init select2 (Support select & search value).
			this.initSelect2Category();
			$('#posts-table').css('display', 'none');
			$('#posts-form').css('display', 'block');
			if (id == null) {
				$('#inpPostsTitle').val(null);
				$('#inpEmailTitle').val(null);
				$('#inpPostsBanner').val(null);
				$('#inpMessageTitle').val(null);
			} else {
				this.getPostsById(id);
			}
		}
	};

	// Fix issues Bootstrap 4 not show file name.
	// More detail: https://stackoverflow.com/questions/48613992/bootstrap-4-file-input-doesnt-show-the-file-name
	$('#inpPostsBanner').change(function (e) {
		if (e.target.files.length) {
			// Replace the "Choose a file" label
			$(this).next('.custom-file-label').html(e.target.files[0].name);
		}
	});

	// Set default view mode is table.
	this.swicthViewPosts(true);

});
function timeAgo(date) {
	const now = new Date();
	const seconds = Math.floor((now - date) / 1000);

	let interval = Math.floor(seconds / 31536000); // 60 * 60 * 24 * 365
	if (interval >= 1) {
		return interval === 1 ? "a year ago" : `${interval} years ago`;
	}
	interval = Math.floor(seconds / 2592000); // 60 * 60 * 24 * 30
	if (interval >= 1) {
		return interval === 1 ? "a month ago" : `${interval} months ago`;
	}
	interval = Math.floor(seconds / 86400); // 60 * 60 * 24
	if (interval >= 1) {
		return interval === 1 ? "a day ago" : `${interval} days ago`;
	}
	interval = Math.floor(seconds / 3600); // 60 * 60
	if (interval >= 1) {
		return interval === 1 ? "an hour ago" : `${interval} hours ago`;
	}
	interval = Math.floor(seconds / 60); // 60
	if (interval >= 1) {
		return interval === 1 ? "a minute ago" : `${interval} minutes ago`;
	}
	return seconds === 1 ? "a second ago" : `${Math.floor(seconds)} seconds ago`;
}
