using HelianzApi.Models;
using HelianzApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class AppointmentsController : ControllerBase
{
    private readonly AppointmentService _service;

    public AppointmentsController(AppointmentService service) => _service = service;

    private List<long> GetAllowedClinics() =>
        User.Claims.Where(c => c.Type == "ClinicNum")
            .Select(c => long.Parse(c.Value)).ToList();

    [HttpGet]
    public async Task<ActionResult<AppointmentSearchResult>> Search(
        [FromQuery] DateTime? dateFrom,
        [FromQuery] DateTime? dateTo,
        [FromQuery] long? provNum,
        [FromQuery] long? clinicNum,
        [FromQuery] long? patNum,
        [FromQuery] int? aptStatus,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50)
    {
        var req = new AppointmentSearchRequest
        {
            DateFrom = dateFrom, DateTo = dateTo,
            ProvNum = provNum, ClinicNum = clinicNum,
            PatNum = patNum, AptStatus = aptStatus,
            Page = page, PageSize = pageSize
        };
        return Ok(await _service.SearchAsync(req, GetAllowedClinics()));
    }

    [HttpGet("today")]
    public async Task<ActionResult<List<Appointment>>> GetToday(
        [FromQuery] long? clinicNum, [FromQuery] long? provNum)
    {
        return Ok(await _service.GetTodayAsync(clinicNum, provNum, GetAllowedClinics()));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Appointment>> GetById(long id)
    {
        var apt = await _service.GetByIdAsync(id, GetAllowedClinics());
        if (apt == null) return NotFound(new { error = "Appointment not found" });
        return Ok(apt);
    }

    [HttpPost]
    public async Task<ActionResult<Appointment>> Create([FromBody] AppointmentCreateRequest req)
    {
        var aptNum = await _service.CreateAsync(req);
        var apt = await _service.GetByIdAsync(aptNum, GetAllowedClinics());
        return CreatedAtAction(nameof(GetById), new { id = aptNum }, apt);
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(long id, [FromBody] AppointmentUpdateRequest req)
    {
        var updated = await _service.UpdateAsync(id, req, GetAllowedClinics());
        if (!updated) return NotFound(new { error = "Appointment not found" });
        return Ok(new { message = "Appointment updated" });
    }

    [HttpPost("{id}/complete")]
    public async Task<IActionResult> SetComplete(long id)
    {
        var updated = await _service.SetCompleteAsync(id, GetAllowedClinics());
        if (!updated) return NotFound(new { error = "Appointment not found" });
        return Ok(new { message = "Appointment marked complete" });
    }
}
