using System.Security.Claims;
using HelianzApi.Models;

namespace HelianzApi.Auth;

/// <summary>
/// Helper to read group permissions from JWT claims and check authorization.
/// Permissions are stored as Perm_{PermType} claims with comma-separated FKey values.
/// A FKey of 0 means "all access" for that permission type.
/// </summary>
public static class PermissionHelper
{
    /// <summary>Check if the current user has a specific permission type.</summary>
    public static bool HasPermission(ClaimsPrincipal user, int permType, long fKey = 0)
    {
        var claim = user.FindFirst($"Perm_{permType}");
        if (claim == null) return false;
        // FKey=0 means access to all items of this type
        if (claim.Value == "0") return true;
        var fkeys = claim.Value.Split(',', StringSplitOptions.RemoveEmptyEntries)
            .Select(long.Parse).ToHashSet();
        return fkeys.Contains(0) || fkeys.Contains(fKey);
    }

    /// <summary>Check if user has any of the given permission types.</summary>
    public static bool HasAnyPermission(ClaimsPrincipal user, params int[] permTypes)
    {
        return permTypes.Any(pt => HasPermission(user, pt));
    }

    /// <summary>Check if user has ALL of the given permission types.</summary>
    public static bool HasAllPermissions(ClaimsPrincipal user, params int[] permTypes)
    {
        return permTypes.All(pt => HasPermission(user, pt));
    }

    /// <summary>Get all FKey values for a given permission type.</summary>
    public static HashSet<long> GetFKeys(ClaimsPrincipal user, int permType)
    {
        var claim = user.FindFirst($"Perm_{permType}");
        if (claim == null) return new();
        return claim.Value.Split(',', StringSplitOptions.RemoveEmptyEntries)
            .Select(long.Parse).ToHashSet();
    }

    // ── Convenience checks for common module access ──

    public static bool CanViewAppointments(ClaimsPrincipal user)
        => HasAnyPermission(user, PermType.AppointmentsModule, PermType.AppointmentCreate,
            PermType.AppointmentEdit, PermType.AppointmentMove);

    public static bool CanViewPatients(ClaimsPrincipal user)
        => HasAnyPermission(user, PermType.FamilyModule, PermType.PatientCreate,
            PermType.PatientEdit);

    public static bool CanViewAccount(ClaimsPrincipal user)
        => HasAnyPermission(user, PermType.AccountModule, PermType.PaymentCreate,
            PermType.PaymentEdit, PermType.AdjustmentCreate, PermType.AdjustmentEdit);

    public static bool CanViewChart(ClaimsPrincipal user)
        => HasAnyPermission(user, PermType.ChartModule, PermType.ProcComplCreate,
            PermType.ProcComplEdit);

    public static bool CanViewReports(ClaimsPrincipal user)
        => HasPermission(user, PermType.Reports);

    public static bool CanViewMobile(ClaimsPrincipal user)
        => HasAnyPermission(user, PermType.MobileWeb, PermType.SecurityAdmin);
}
