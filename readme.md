---
title: sharepoint-governance
description: Describe the main purpose of this kitchen
---

#
# SharePoint Governance Service

This services is providing methods for getting easy access to information about e.g. who is responsible for the content of any given page as well as easy access to who is the owners of the site.

## Examples

```powershell
sharepoint-governance page info https://christianiabpos.sharepoint.com/sites/nexiintra-home -o json
```

Result
```json
{
  "versions": [
    {
      "isTranslation": null,
      "folder": null,
      "page": "Home.aspx",
      "lastModified": "2024-03-15T10:34:26Z",
      "lastModifiedBy": "fabrizio.mele@nexigroup.com"
    },
    {
      "isTranslation": true,
      "folder": "it-it",
      "page": "Home.aspx",
      "lastModified": "2024-03-15T10:33:57Z",
      "lastModifiedBy": "fabrizio.mele@nexigroup.com"
    }
  ],
  "page": "home.aspx",
  "siteowners": [
    {
      "Title": "Achour Karim (Consultant)",
      "UserPrincipalName": "karim.achour@external.nexigroup.com",
      "Email": "karim.achour@external.nexigroup.com"
    },
    {
      "Title": "Corrias Cristina (Consultant)",
      "UserPrincipalName": "cristina.corrias@external.nexigroup.com",
      "Email": "cristina.corrias@external.nexigroup.com"
    },
    {
      "Title": "Corrias Stefania (Consultant)",
      "UserPrincipalName": "stefania.corrias@external.nexigroup.com",
      "Email": "stefania.corrias@external.nexigroup.com"
    },
    {
      "Title": "Ferrando Marco (Consultant)",
      "UserPrincipalName": "marco.ferrando@external.nexigroup.com",
      "Email": "marco.ferrando@external.nexigroup.com"
    },
    {
      "Title": "Mele Fabrizio",
      "UserPrincipalName": "fabrizio.mele@nexigroup.com",
      "Email": "fabrizio.mele@nexigroup.com"
    },
    {
      "Title": "Russi Andrea (Consultant)",
      "UserPrincipalName": "andrea.russi@external.nexigroup.com",
      "Email": "andrea.russi@external.nexigroup.com"
    },
    {
      "Title": "Simeoni Fabrizio (Consultant)",
      "UserPrincipalName": "fabrizio.simeoni@external.nexigroup.com",
      "Email": "fabrizio.simeoni@external.nexigroup.com"
    },
    {
      "Title": "Simone Riccardo (Consultant)",
      "UserPrincipalName": "riccardo.simone@external.nexigroup.com",
      "Email": "riccardo.simone@external.nexigroup.com"
    },
    {
      "Title": "Stucchi Marco",
      "UserPrincipalName": "marco.stucchi@nexigroup.com",
      "Email": "marco.stucchi@nexigroup.com"
    }
  ]
}

```

