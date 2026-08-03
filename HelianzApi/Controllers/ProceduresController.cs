using HelianzApi.Models;
using HelianzApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProceduresController : ControllerBase
{
    private readonly ProcedureService _service;

    public ProceduresController(ProcedureService service) => _service = service;

    private List<long> GetAllowedClinics() =>
        User.Claims.Where(c => c.Type == "ClinicNum")
            .Select(c => long.Parse(c.Value)).ToList();

    [HttpGet]
    public async Task<ActionResult<ProcedureSearchResult>> Search(
        [FromQuery] long? patNum, [FromQuery] long? clinicNum,
        [FromQuery] long? provNum, [FromQuery] DateTime? dateFrom,
        [FromQuery] DateTime? dateTo, [FromQuery] int? procStatus,
        [FromQuery] int page = 1, [FromQuery] int pageSize = 50)
    {
        var req = new ProcedureSearchRequest
        {
            PatNum = patNum, ClinicNum = clinicNum, ProvNum = provNum,
            DateFrom = dateFrom, DateTo = dateTo, ProcStatus = procStatus,
            Page = page, PageSize = pageSize
        };
        return Ok(await _service.SearchAsync(req, GetAllowedClinics()));
    }

    [HttpGet("chart/{patNum}")]
    public async Task<ActionResult<ToothChart>> GetToothChart(long patNum)
    {
        var chart = await _service.GetToothChartAsync(patNum, GetAllowedClinics());
        if (chart.PatNum == 0)
            return NotFound(new { error = "Patient not found" });
        return Ok(chart);
    }

    [HttpPost]
    public async Task<ActionResult> Create([FromBody] ProcedureCreateRequest req)
    {
        var procNum = await _service.CreateAsync(req);
        return Created($"/api/procedures/{procNum}", new { ProcNum = procNum });
    }

    [HttpPost("{id}/complete")]
    public async Task<IActionResult> SetComplete(long id)
    {
        var ok = await _service.SetCompleteAsync(id, GetAllowedClinics());
        if (!ok) return NotFound(new { error = "Procedure not found" });
        return Ok(new { message = "Procedure marked complete" });
    }
}
