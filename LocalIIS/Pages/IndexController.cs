using Microsoft.AspNetCore.Mvc;

namespace LocalIIS.Pages
{
    public class IndexController : Controller
    {
        [Route("/Count")]
        public IActionResult Count()
        {
            return Ok();
        }
    }
}
