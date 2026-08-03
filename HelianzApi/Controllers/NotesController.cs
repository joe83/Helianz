using System.Security.Claims;
using HelianzApi.Models;
using HelianzApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class NotesController : ControllerBase
{
    private readonly NoteService _service;

    public NotesController(NoteService service) => _service = service;

    private List<long> GetAllowedClinics() =>
        User.Claims.Where(c => c.Type == "ClinicNum")
            .Select(c => long.Parse(c.Value)).ToList();

    private long GetUserId() =>
        long.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "0");

    [HttpGet]
    public async Task<ActionResult<NoteSearchResult>> Search(
        [FromQuery] long? patNum, [FromQuery] long? clinicNum,
        [FromQuery] DateTime? dateFrom, [FromQuery] DateTime? dateTo,
        [FromQuery] int page = 1, [FromQuery] int pageSize = 20)
    {
        var req = new NoteSearchRequest
        {
            PatNum = patNum, ClinicNum = clinicNum,
            DateFrom = dateFrom, DateTo = dateTo,
            Page = page, PageSize = pageSize
        };
        return Ok(await _service.SearchAsync(req, GetAllowedClinics()));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ClinicalNote>> GetById(long id)
    {
        var note = await _service.GetByIdAsync(id, GetAllowedClinics());
        if (note == null) return NotFound(new { error = "Note not found" });
        return Ok(note);
    }

    [HttpPost]
    public async Task<ActionResult> Create([FromBody] NoteCreateRequest req)
    {
        var commlogNum = await _service.CreateAsync(req, GetUserId());
        var note = await _service.GetByIdAsync(commlogNum, GetAllowedClinics());
        return CreatedAtAction(nameof(GetById), new { id = commlogNum }, note);
    }
}
