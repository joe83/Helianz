using HelianzApi.Models;
using HelianzApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PrescriptionsController : ControllerBase
{
    private readonly PrescriptionService _service;

    public PrescriptionsController(PrescriptionService service) => _service = service;

    private List<long> GetAllowedClinics() =>
        User.Claims.Where(c => c.Type == "ClinicNum")
            .Select(c => long.Parse(c.Value)).ToList();

    [HttpGet]
    public async Task<ActionResult<PrescriptionSearchResult>> Search(
        [FromQuery] long? patNum, [FromQuery] long? clinicNum,
        [FromQuery] DateTime? dateFrom, [FromQuery] DateTime? dateTo,
        [FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        var req = new PrescriptionSearchRequest
        {
            PatNum = patNum, ClinicNum = clinicNum,
            DateFrom = dateFrom, DateTo = dateTo,
            Page = page, PageSize = pageSize
        };
        return Ok(await _service.SearchAsync(req, GetAllowedClinics()));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Prescription>> GetById(long id)
    {
        var rx = await _service.GetByIdAsync(id, GetAllowedClinics());
        if (rx == null) return NotFound(new { error = "Prescription not found" });
        return Ok(rx);
    }

    [HttpPost]
    public async Task<ActionResult> Create([FromBody] PrescriptionCreateRequest req)
    {
        var rxNum = await _service.CreateAsync(req);
        var rx = await _service.GetByIdAsync(rxNum, GetAllowedClinics());
        return CreatedAtAction(nameof(GetById), new { id = rxNum }, rx);
    }
}
