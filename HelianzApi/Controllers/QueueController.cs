using HelianzApi.Models;
using HelianzApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HelianzApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class QueueController : ControllerBase
{
    private readonly QueueService _service;

    public QueueController(QueueService service) => _service = service;

    /// <summary>
    /// Get full queue state for TV Screen Display (Public for TV screens)
    /// </summary>
    [HttpGet("display")]
    [AllowAnonymous]
    public async Task<ActionResult<QueueDisplayData>> GetDisplayData([FromQuery] long clinicNum = 0)
    {
        var data = await _service.GetDisplayDataAsync(clinicNum);
        return Ok(data);
    }

    /// <summary>
    /// Trigger a queue call for a patient
    /// </summary>
    [HttpPost("call")]
    [AllowAnonymous]
    public async Task<ActionResult<QueueItem>> CallPatient([FromBody] CallPatientRequest req)
    {
        var item = await _service.CallPatientAsync(req);
        if (item == null) return NotFound(new { error = "Appointment not found" });
        return Ok(item);
    }

    /// <summary>
    /// Mark patient arrived in waiting room
    /// </summary>
    [HttpPost("arrive/{aptNum}")]
    [AllowAnonymous]
    public async Task<IActionResult> Arrive(long aptNum)
    {
        var success = await _service.SetArrivedAsync(aptNum);
        if (!success) return NotFound(new { error = "Appointment not found" });
        return Ok(new { message = "Patient arrival recorded" });
    }

    /// <summary>
    /// Mark patient seated in operatory room
    /// </summary>
    [HttpPost("seat/{aptNum}")]
    [AllowAnonymous]
    public async Task<IActionResult> Seat(long aptNum, [FromQuery] long? opNum)
    {
        var success = await _service.SetSeatedAsync(aptNum, opNum);
        if (!success) return NotFound(new { error = "Appointment not found" });
        return Ok(new { message = "Patient seated in operatory" });
    }

    /// <summary>
    /// Mark patient dismissed / consultation completed
    /// </summary>
    [HttpPost("dismiss/{aptNum}")]
    [AllowAnonymous]
    public async Task<IActionResult> Dismiss(long aptNum)
    {
        var success = await _service.SetDismissedAsync(aptNum);
        if (!success) return NotFound(new { error = "Appointment not found" });
        return Ok(new { message = "Patient dismissed" });
    }

    /// <summary>
    /// Get educational video playlist
    /// </summary>
    [HttpGet("playlist")]
    [AllowAnonymous]
    public ActionResult<List<VideoItem>> GetPlaylist()
    {
        return Ok(_service.GetDefaultPlaylist());
    }
}
