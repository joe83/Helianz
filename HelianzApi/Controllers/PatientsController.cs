using System.Security.Claims;
using HelianzApi.Models;
using HelianzApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PatientsController : ControllerBase
{
    private readonly PatientService _service;

    public PatientsController(PatientService service) => _service = service;

    private List<long> GetAllowedClinics()
    {
        return User.Claims
            .Where(c => c.Type == "ClinicNum")
            .Select(c => long.Parse(c.Value))
            .ToList();
    }

    [HttpGet]
    public async Task<ActionResult<PatientSearchResult>> Search(
        [FromQuery] string? query,
        [FromQuery] long? clinicNum,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 20)
    {
        var req = new PatientSearchRequest
        {
            Query = query,
            ClinicNum = clinicNum,
            Page = page,
            PageSize = pageSize
        };
        return Ok(await _service.SearchAsync(req, GetAllowedClinics()));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Patient>> GetById(long id)
    {
        var patient = await _service.GetByIdAsync(id, GetAllowedClinics());
        if (patient == null)
            return NotFound(new { error = "Patient not found" });
        return Ok(patient);
    }

    [HttpPost]
    public async Task<ActionResult<Patient>> Create([FromBody] PatientCreateRequest req)
    {
        var patNum = await _service.CreateAsync(req);
        var patient = await _service.GetByIdAsync(patNum, GetAllowedClinics());
        return CreatedAtAction(nameof(GetById), new { id = patNum }, patient);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] PatientUpdateRequest req)
    {
        var updated = await _service.UpdateAsync(id, req, GetAllowedClinics());
        if (!updated)
            return NotFound(new { error = "Patient not found or access denied" });
        return Ok(new { message = "Patient updated" });
    }
}
