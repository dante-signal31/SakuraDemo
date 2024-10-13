using Godot;

namespace SakuraDemo.Scripts;

[Tool]
public partial class LeafEmitter : GpuParticles2D
{
    [ExportCategory("CONFIGURATION")] [Export]
    private float _oscillationMultiplier = 40.0f; 
    [Export(PropertyHint.Range, "0.0, 10.0, 0.001")] 
    public float WindStrength { get; set; }
    [Export(PropertyHint.Range, "-1.0, 1.0, 0.001")] 
    public float HorizontalOffset { get; set; }

    public float Time { get; set; }

    private Vector2 _initialPosition;
    private Vector2 _lastPosition;
    private bool _minimumReached = false;
    private bool _maximumReached = false;

    private float get_oscillation(
        float windStrength,
        float horizontalOffset,
        float time)
    {
        return windStrength * (Mathf.Sin(time) + horizontalOffset);
    }

    public override void _Ready()
    {
        base._Ready();
        _initialPosition = Position;
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
        float oscillation = _oscillationMultiplier * 
                            get_oscillation(WindStrength, HorizontalOffset, Time);
        Position = _initialPosition with { X = _initialPosition.X + oscillation };
    }
}