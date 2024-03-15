// -------------------------------------------------------------------
// Generated by 365admin-publish
// -------------------------------------------------------------------

package endpoints

import (
	"net/http"

	chi "github.com/go-chi/chi/v5"
	"github.com/swaggest/rest/nethttp"
	"github.com/swaggest/rest/web"
)

func AddEndpoints(s *web.Service, jwtAuth func(http.Handler) http.Handler) {
	s.Route("/v1", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			//r.Use(adminAuth, nethttp.HTTPBasicSecurityMiddleware(s.OpenAPICollector, "User", "User access"))
			r.Use(jwtAuth, nethttp.HTTPBearerSecurityMiddleware(s.OpenAPICollector, "Bearer", "", ""))
			//	r.Use(rateLimitByAppId(50))
			//r.Method(http.MethodPost, "/", nethttp.NewHandler(ExchangeCreateRoomsPost()))
			r.Method(http.MethodPost, "/sharepoint/pageinfo", nethttp.NewHandler(SharepointPageinfoPost()))

		})
	})

}
