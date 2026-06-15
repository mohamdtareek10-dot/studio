
"use client";

import { useState } from "react";
import { Navigation } from "@/components/Navigation";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Checkbox } from "@/components/ui/checkbox";
import { generatePersonalizedWorkout, type GeneratePersonalizedWorkoutOutput } from "@/ai/flows/generate-personalized-workout";
import { Loader2, Zap, Clock, Target, Dumbbell, PlayCircle } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { Badge } from "@/components/ui/badge";

const EQUIPMENT_OPTIONS = ["Punching Bag", "Gloves", "Focus Mitts", "Jump Rope", "No Equipment", "Resistance Bands", "Kettlebell"];
const GOAL_OPTIONS = ["Strength", "Endurance", "Technique", "Flexibility", "Speed", "Agility"];

export default function GeneratorPage() {
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<GeneratePersonalizedWorkoutOutput | null>(null);
  const [skillLevel, setSkillLevel] = useState("beginner");
  const [selectedGoals, setSelectedGoals] = useState<string[]>([]);
  const [selectedEquipment, setSelectedEquipment] = useState<string[]>([]);
  const [pastPerformance, setPastPerformance] = useState("");
  const { toast } = useToast();

  const handleGoalToggle = (goal: string) => {
    setSelectedGoals(prev => 
      prev.includes(goal) ? prev.filter(g => g !== goal) : [...prev, goal]
    );
  };

  const handleEquipmentToggle = (item: string) => {
    setSelectedEquipment(prev => 
      prev.includes(item) ? prev.filter(i => i !== item) : [...prev, item]
    );
  };

  const handleGenerate = async () => {
    if (selectedGoals.length === 0) {
      toast({ title: "Please select at least one goal", variant: "destructive" });
      return;
    }
    setLoading(true);
    try {
      const output = await generatePersonalizedWorkout({
        skillLevel,
        goals: selectedGoals,
        equipment: selectedEquipment,
        pastPerformance: pastPerformance || "I am ready for a new session."
      });
      setResult(output);
    } catch (error) {
      toast({ title: "Failed to generate workout", description: "Something went wrong. Please try again.", variant: "destructive" });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen pb-24 md:pt-20">
      <Navigation />
      <main className="max-w-4xl mx-auto px-4 py-8 space-y-8">
        <header className="text-center">
          <Badge variant="outline" className="mb-2 text-primary border-primary/30 font-bold uppercase tracking-widest text-[10px]">AI-Powered Intelligence</Badge>
          <h1 className="text-4xl font-headline font-bold text-foreground">WORKOUT GENERATOR</h1>
          <p className="text-muted-foreground mt-2 max-w-xl mx-auto">Input your details and let Iron Wolf AI craft your perfect training session.</p>
        </header>

        <div className="grid grid-cols-1 gap-8">
          {!result ? (
            <Card className="border-primary/20 bg-card/50">
              <CardContent className="pt-6 space-y-8">
                <div className="space-y-4">
                  <Label>Skill Level</Label>
                  <Select value={skillLevel} onValueChange={setSkillLevel}>
                    <SelectTrigger className="w-full">
                      <SelectValue placeholder="Select skill level" />
                    </SelectTrigger>
                    <SelectContent>
                      <SelectItem value="beginner">Beginner</SelectItem>
                      <SelectItem value="intermediate">Intermediate</SelectItem>
                      <SelectItem value="advanced">Advanced / Pro</SelectItem>
                    </SelectContent>
                  </Select>
                </div>

                <div className="space-y-4">
                  <Label>Training Goals</Label>
                  <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                    {GOAL_OPTIONS.map(goal => (
                      <div key={goal} className="flex items-center space-x-2 bg-muted p-2 rounded-md border border-border">
                        <Checkbox 
                          id={`goal-${goal}`} 
                          checked={selectedGoals.includes(goal)} 
                          onCheckedChange={() => handleGoalToggle(goal)}
                        />
                        <label htmlFor={`goal-${goal}`} className="text-sm font-medium leading-none cursor-pointer">{goal}</label>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="space-y-4">
                  <Label>Available Equipment</Label>
                  <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                    {EQUIPMENT_OPTIONS.map(item => (
                      <div key={item} className="flex items-center space-x-2 bg-muted p-2 rounded-md border border-border">
                        <Checkbox 
                          id={`equip-${item}`} 
                          checked={selectedEquipment.includes(item)} 
                          onCheckedChange={() => handleEquipmentToggle(item)}
                        />
                        <label htmlFor={`equip-${item}`} className="text-sm font-medium leading-none cursor-pointer">{item}</label>
                      </div>
                    ))}
                  </div>
                </div>

                <div className="space-y-4">
                  <Label>Past Performance & Context</Label>
                  <Textarea 
                    placeholder="Tell AI how your last session felt or specific techniques you want to improve..." 
                    value={pastPerformance}
                    onChange={(e) => setPastPerformance(e.target.value)}
                    className="min-h-[100px]"
                  />
                </div>

                <Button 
                  className="w-full electric-glow h-12 text-lg" 
                  onClick={handleGenerate}
                  disabled={loading}
                >
                  {loading ? (
                    <><Loader2 className="mr-2 h-5 w-5 animate-spin" /> ANALYZING...</>
                  ) : (
                    <><Zap className="mr-2 h-5 w-5" /> GENERATE ROUTINE</>
                  )}
                </Button>
              </CardContent>
            </Card>
          ) : (
            <div className="space-y-6 animate-in fade-in slide-in-from-bottom-4 duration-500">
              <div className="flex justify-between items-center">
                <Button variant="ghost" onClick={() => setResult(null)}>← Start Over</Button>
                <Button className="electric-glow"><PlayCircle className="mr-2 w-4 h-4" /> Start Workout</Button>
              </div>

              <Card className="border-primary/50 overflow-hidden">
                <div className="bg-primary p-6 text-primary-foreground">
                  <h2 className="text-2xl font-headline font-bold uppercase tracking-tight">{result.workoutName}</h2>
                  <div className="flex gap-4 mt-2 opacity-90 text-sm">
                    <span className="flex items-center gap-1"><Clock className="w-4 h-4" /> {result.totalDurationMinutes} minutes</span>
                    <span className="flex items-center gap-1"><Dumbbell className="w-4 h-4" /> {selectedEquipment.length} items used</span>
                  </div>
                </div>
                <CardContent className="pt-6 space-y-8">
                  {result.sections.map((section, sIdx) => (
                    <div key={sIdx} className="space-y-4">
                      <h3 className="text-lg font-headline font-bold text-primary flex items-center gap-2">
                        <span className="w-8 h-8 rounded bg-primary/10 flex items-center justify-center text-xs">{sIdx + 1}</span>
                        {section.name}
                      </h3>
                      <div className="grid gap-3">
                        {section.exercises.map((exercise, eIdx) => (
                          <div key={eIdx} className="bg-muted/30 p-4 rounded-xl border border-border/50 group hover:border-primary/30 transition-colors">
                            <div className="flex justify-between items-start mb-2">
                              <h4 className="font-bold text-foreground group-hover:text-primary transition-colors">{exercise.name}</h4>
                              <div className="flex gap-2">
                                {exercise.durationMinutes && <Badge variant="secondary">{exercise.durationMinutes}m</Badge>}
                                {exercise.repsOrTime && <Badge variant="outline">{exercise.repsOrTime}</Badge>}
                              </div>
                            </div>
                            <p className="text-sm text-muted-foreground">{exercise.description}</p>
                            {exercise.focus && (
                              <div className="flex gap-2 mt-3">
                                {exercise.focus.map(f => (
                                  <span key={f} className="text-[10px] uppercase tracking-tighter text-muted-foreground px-2 py-0.5 bg-background rounded-full border border-border">
                                    {f}
                                  </span>
                                ))}
                              </div>
                            )}
                          </div>
                        ))}
                      </div>
                    </div>
                  ))}
                </CardContent>
              </Card>
            </div>
          )}
        </div>
      </main>
    </div>
  );
}
