using System.Security.Claims;
using HelianzApi.Models;
using HelianzApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class PaymentsController : ControllerBase
{
    private readonly PaymentService _service;

    public PaymentsController(PaymentService service) => _service = service;

    private List<long> GetAllowedClinics() =>
        User.Claims.Where(c => c.Type == "ClinicNum")
            .Select(c => long.Parse(c.Value)).ToList();

    private long GetUserId() =>
        long.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier) ?? "0");

    [HttpGet]
    public async Task<ActionResult<PaymentSearchResult>> Search(
        [FromQuery] long? patNum, [FromQuery] long? clinicNum,
        [FromQuery] DateTime? dateFrom, [FromQuery] DateTime? dateTo,
        [FromQuery] int page = 1, [FromQuery] int pageSize = 50)
    {
        var req = new PaymentSearchRequest
        {
            PatNum = patNum, ClinicNum = clinicNum,
            DateFrom = dateFrom, DateTo = dateTo,
            Page = page, PageSize = pageSize
        };
        return Ok(await _service.SearchAsync(req, GetAllowedClinics()));
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Payment>> GetById(long id)
    {
        var payment = await _service.GetByIdAsync(id, GetAllowedClinics());
        if (payment == null) return NotFound(new { error = "Payment not found" });
        return Ok(payment);
    }

    [HttpPost]
    public async Task<ActionResult> Create([FromBody] PaymentCreateRequest req)
    {
        var payNum = await _service.CreateAsync(req, GetUserId());
        var payment = await _service.GetByIdAsync(payNum, GetAllowedClinics());
        return CreatedAtAction(nameof(GetById), new { id = payNum }, payment);
    }
}
