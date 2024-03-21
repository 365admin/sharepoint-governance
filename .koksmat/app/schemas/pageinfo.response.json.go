package schemas

type PageinfoResponse struct {
	Page       string `json:"page"`
	Siteowners []struct {
		Email             string `json:"Email"`
		Title             string `json:"Title"`
		UserPrincipalName string `json:"UserPrincipalName"`
	} `json:"siteowners"`
	Versions []struct {
		Folder         interface{} `json:"folder"`
		IsTranslation  bool        `json:"isTranslation"`
		LastModified   string      `json:"lastModified"`
		LastModifiedBy string      `json:"lastModifiedBy"`
		Page           string      `json:"page"`
	} `json:"versions"`
}
