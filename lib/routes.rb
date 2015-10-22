module Arcgis
  module Routes
    ROUTES = {
      root: {
        search:         "GET /search",
        generate_token: "POST /generateToken"
      },

      group: {
        fetch:        "GET /community/groups/:id",
        items:        "GET /content/groups/:id/items",
        users:        "GET /community/groups/:id/users",
        applications: "GET /community/groups/:id/applications",
        add_item:     "POST /content/groups/:id/addItem",
        update:       "POST /community/groups/:id/update",
        reassign:     "POST /community/groups/:id/reassign",
        delete:       "POST /community/groups/:id/delete",
        join:         "POST /community/groups/:id/join",
        invite:       "POST /community/groups/:id/invite",
        leave:        "POST /community/groups/:id/leave",
        remove_users: "POST /community/groups/:id/removeUsers",
        create:       "POST /community/createGroup"
      },

      item: {
        fetch:               "GET /content/items/:id",
        comments:            "GET /content/items/:id/comments",
        rating:              "GET /content/items/:id/rating",
        related_items:       "GET /content/items/:id/relatedItems",
        data:                "GET /content/items/:id/data",
        groups:              "GET /content/items/:id/groups",
        add_relationship:    "POST /content/items/:id/addRelationship",
        delete_relationship: "POST /content/items/:id/deleteRelationship",
        add_comment:         "POST /content/items/:id/addComment",
        add_rating:          "POST /content/items/:id/addRating",
        delete_rating:       "POST /content/items/:id/deleteRating",
        share:               "POST /content/items/:id/share",
        unshare:             "POST /content/items/:id/unshare",
        delete:              "POST /content/users/:username/items/:id/delete",
        create:              "POST /content/users/:username/addItem"
      },

      comment: {
        fetch:  "GET /content/items/:item_id/comments/:id",
        update: "POST /content/items/:item_id/comments/:id/update",
        delete: "POST /content/items/:item_id/comments/:id/delete"
      },

      feature: {
        analyze:  "POST /content/features/analyze",
        generate: "GET /content/features/generate"
      },

      user: {
        fetch:               "GET /community/users/:username",
        items:               "GET /content/users/:username/items",
        add_relationship:    "POST /content/users/:username/addRelationship",
        delete_relationship: "POST /content/users/:username/deleteRelationship",
        publish_item:        "POST /content/users/:username/publish",
        export_item:         "POST /content/users/:username/exportItem",
        share_items:         "POST /content/users/:username/shareItems",
        unshare_items:       "POST /content/users/:username/unshareItems",
        move_items:          "POST /content/users/:username/moveItems",
        notifications:       "GET /community/users/:username/notifications",
        tags:                "GET /community/users/:username/tags",
        invitations:         "GET /community/users/:username/invitations",
        update:              "POST /community/users/:username/update",
        delete:              "POST /community/users/:username/delete",
        create_folder:       "POST /content/users/:username/createFolder",
        delete_folder:       "POST /content/users/:username/deleteFolder",
        add_items:           "POST /content/users/:username/addItems",
        add_item:            "POST /content/users/:username/addItem",
        update_items:        "POST /content/users/:username/updateItems",
        delete_items:        "POST /content/users/:username/deleteItems",
        create_service:      "POST /content/users/:username/createService"
      }
    }
  end
end
