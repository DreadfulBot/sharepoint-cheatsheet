# Content

- [Content](#content)
  - [Object serialization](#object-serialization)
    - [Serialize](#serialize)
    - [Deserialize](#deserialize)
    - [Registering Wcf-service](#registering-wcf-service)
  - [WebService.svc](#webservicesvc)
    - [Strong name generation](#strong-name-generation)
    - [IWebService.cs](#iwebservicecs)
    - [WebService.svc.cs](#webservicesvccs)

---

## Object serialization

### Serialize

```c#
var found = Locator.GetService<IEmployeeService>().GetAllEmployees(web.Site, request);
File.WriteAllText(@"C:\temp\get-all-employees.json", JsonConvert.SerializeObject(found));
```

### Deserialize

```c#
var fileContent = File.ReadAllText(@"C:\temp\get-all-employees.json");
var allEmployees = JsonConvert.DeserializeObject<EmployeesSearchResult>(fileContent);
```


### Registering Wcf-service

Add Mapped folder -> ISAPI

Add those files here:

## WebService.svc

```c#
<%@ ServiceHost Language="C#" 
    Factory="Microsoft.SharePoint.Client.Services.MultipleBaseAddressWebServiceHostFactory, Microsoft.SharePoint.Client.ServerRuntime, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c"
    Service="TestProject.ISAPI.TestProject.WebService, TestProject, Version=1.0.0.0, Culture=neutral, PublicKeyToken=96456a10469196f2" %>
```

Where service = *STRONG_NAME*

### Strong name generation

1. Title: _Strong Name_
2. Command: _Powershell.exe_
3. Arguments: _-command "[System.Reflection.AssemblyName]::GetAssemblyName(\"$(TargetPath)\").FullName"_
4. Check "Use output window"

### IWebService.cs
```c#
using System.ServiceModel;
using System.ServiceModel.Web;

namespace TestProject.ISAPI.TestProject
{
    [ServiceContract]
    interface IWebService
    {
        [OperationContract]
        [WebGet(UriTemplate = "test", ResponseFormat = WebMessageFormat.Json,
            BodyStyle = WebMessageBodyStyle.Bare )]
        string Test();
    }
}
```

### WebService.svc.cs
```c#
using System;
using System.Runtime.InteropServices;
using System.ServiceModel.Activation;

namespace TestProject.ISAPI.TestProject
{
    [Guid("54CD32E4-F11D-4CE3-81CA-216866A3F02E"),
            AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Required)]
    public class WebService : IWebService
    {
        public string Test()
        {
            return "test wcf service";
        }
    }
}

```