using HelianzApi.Models;
using HelianzApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ReferenceController : ControllerBase
{
    private readonly ReferenceDataService _service;

    public ReferenceController(ReferenceDataService service) => _service = service;

    [HttpGet]
    public async Task<ActionResult<ReferenceData>> GetAll([FromQuery] long clinicNum = 0)
    {
        return Ok(await _service.GetAllAsync(clinicNum));
    }

    [HttpGet("clinics")]
    [AllowAnonymous]
    public async Task<ActionResult<List<ClinicInfo>>> GetClinics()
    {
        var all = await _service.GetAllAsync(0);
        return Ok(all.Clinics);
    }
}
